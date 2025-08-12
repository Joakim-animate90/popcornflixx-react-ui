#!/bin/bash

# PopcornFlix Frontend Docker Runner Script

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

# Default values
API_URL="${API_URL:-http://44.236.112.239:30081}"
PORT="${PORT:-3000}"
IMAGE_NAME="popcornflix-frontend"

echo "🎬 PopcornFlix Frontend Docker Runner"
echo "====================================="
echo "API URL: $API_URL"
echo "Port: $PORT"
echo "====================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker first."
    exit 1
fi

print_status "Building Docker image with API URL: $API_URL"
if docker build --build-arg REACT_APP_API_URL="$API_URL" -t "$IMAGE_NAME" .; then
    print_success "Docker image built successfully!"
else
    print_error "Failed to build Docker image"
    exit 1
fi

print_status "Starting container on port $PORT..."
if docker run -d --name popcornflix-frontend-container -p "$PORT:80" "$IMAGE_NAME"; then
    print_success "Container started successfully!"
    print_success "🚀 PopcornFlix is now running at: http://localhost:$PORT"
    
    # Show container status
    echo ""
    print_status "Container Status:"
    docker ps -f name=popcornflix-frontend-container
    
    echo ""
    print_status "Useful commands:"
    echo "  View logs:     docker logs -f popcornflix-frontend-container"
    echo "  Stop:          docker stop popcornflix-frontend-container"
    echo "  Remove:        docker rm popcornflix-frontend-container"
    echo "  Health check:  curl http://localhost:$PORT/health"
else
    print_error "Failed to start container"
    exit 1
fi
