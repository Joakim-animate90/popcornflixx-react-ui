#!/bin/bash

echo "🏗️  Testing Docker Build for PopcornFlix Frontend"
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

print_status "Docker is running ✅"

# Build for AMD64 (most compatible)
print_status "Building for AMD64 architecture..."
if docker build --platform linux/amd64 -t popcornflix-frontend:amd64 .; then
    print_success "AMD64 build completed successfully!"
else
    print_error "AMD64 build failed!"
    exit 1
fi

# Test the built image
print_status "Testing the built image..."
CONTAINER_ID=$(docker run -d -p 8080:80 popcornflix-frontend:amd64)

# Wait a moment for the container to start
sleep 5

# Test health endpoint
if curl -f http://localhost:8080/health > /dev/null 2>&1; then
    print_success "Health check passed!"
else
    print_warning "Health check failed - container might still be starting"
fi

# Test main page
if curl -f http://localhost:8080 > /dev/null 2>&1; then
    print_success "Main page accessible!"
    print_status "🎉 Build test completed successfully!"
    print_status "You can access the app at: http://localhost:8080"
else
    print_error "Main page not accessible"
fi

print_status "Container ID: $CONTAINER_ID"
print_status "To stop the container: docker stop $CONTAINER_ID"
print_status "To view logs: docker logs $CONTAINER_ID"

# Optionally try ARM64 build if on compatible system
if [[ $(uname -m) == "arm64" ]] || [[ $(uname -m) == "aarch64" ]]; then
    print_status "Detected ARM architecture, testing ARM64 build..."
    if docker build --platform linux/arm64 -t popcornflix-frontend:arm64 .; then
        print_success "ARM64 build completed successfully!"
    else
        print_warning "ARM64 build failed - this is expected on some systems"
    fi
fi
