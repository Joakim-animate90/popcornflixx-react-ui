#!/bin/bash

echo "🔒 Security Scanner for PopcornFlix Frontend"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Default image name
IMAGE_NAME="popcornflix-frontend:latest"

# Check if custom image name provided
if [ ! -z "$1" ]; then
    IMAGE_NAME="$1"
fi

print_status "Scanning image: $IMAGE_NAME"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

# Check if image exists
if ! docker image inspect "$IMAGE_NAME" > /dev/null 2>&1; then
    print_warning "Image $IMAGE_NAME not found locally. Building it first..."
    if ! docker build -t "$IMAGE_NAME" .; then
        print_error "Failed to build image"
        exit 1
    fi
fi

print_success "Image found: $IMAGE_NAME"

# Check if Trivy is installed
if ! command -v trivy &> /dev/null; then
    print_status "Trivy not found. Installing Trivy..."
    
    # Install Trivy based on OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install trivy
        else
            print_error "Homebrew not found. Please install Trivy manually: https://trivy.dev/installation/"
            exit 1
        fi
    else
        print_error "Unsupported OS. Please install Trivy manually: https://trivy.dev/installation/"
        exit 1
    fi
fi

print_success "Trivy is available"

# Run security scan
print_status "Running security scan..."
echo "========================================"

# Run Trivy scan with table output
trivy image --severity CRITICAL,HIGH,MEDIUM "$IMAGE_NAME"

# Generate JSON report
print_status "Generating detailed report..."
trivy image --format json --output trivy-report.json "$IMAGE_NAME"

# Count vulnerabilities
CRITICAL=$(jq -r '.Results[]?.Vulnerabilities[]? | select(.Severity=="CRITICAL") | .VulnerabilityID' trivy-report.json 2>/dev/null | wc -l || echo "0")
HIGH=$(jq -r '.Results[]?.Vulnerabilities[]? | select(.Severity=="HIGH") | .VulnerabilityID' trivy-report.json 2>/dev/null | wc -l || echo "0")
MEDIUM=$(jq -r '.Results[]?.Vulnerabilities[]? | select(.Severity=="MEDIUM") | .VulnerabilityID' trivy-report.json 2>/dev/null | wc -l || echo "0")

echo ""
echo "========================================"
print_status "Security Scan Summary"
echo "========================================"
echo -e "Critical vulnerabilities: ${RED}$CRITICAL${NC}"
echo -e "High vulnerabilities:     ${YELLOW}$HIGH${NC}"
echo -e "Medium vulnerabilities:   ${BLUE}$MEDIUM${NC}"

if [ "$CRITICAL" -gt 0 ]; then
    print_error "Critical vulnerabilities found! Please address them immediately."
    exit 1
elif [ "$HIGH" -gt 5 ]; then
    print_warning "High number of high-severity vulnerabilities found."
    exit 1
else
    print_success "Security scan completed. Image appears to be reasonably secure."
fi

print_status "Detailed report saved to: trivy-report.json"
print_status "Scan completed for image: $IMAGE_NAME"
