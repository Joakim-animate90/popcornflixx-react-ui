#!/bin/bash

# Quick Docker build and run script for PopcornFlix Frontend

set -e

# Configuration
API_URL="${API_URL:-http://44.236.112.239:30081}"
IMAGE_NAME="popcornflix-frontend"
CONTAINER_NAME="popcornflix-frontend-container"
HOST_PORT="${HOST_PORT:-3000}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🐳 Building PopcornFlix Frontend Docker Image${NC}"
echo "=================================================="
echo "API URL: $API_URL"
echo "Image Name: $IMAGE_NAME"
echo "Host Port: $HOST_PORT"
echo "=================================================="

# Stop and remove existing container if running
if docker ps -a --format 'table {{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}Stopping existing container...${NC}"
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi

# Build the image with the API URL
echo -e "${BLUE}Building Docker image...${NC}"
docker build --build-arg REACT_APP_API_URL="$API_URL" -t $IMAGE_NAME .

# Run the container
echo -e "${BLUE}Starting container...${NC}"
docker run -d \
    --name $CONTAINER_NAME \
    -p $HOST_PORT:80 \
    $IMAGE_NAME

echo -e "${GREEN}✅ Container started successfully!${NC}"
echo ""
echo "📱 Frontend URL: http://localhost:$HOST_PORT"
echo "🔗 API URL: $API_URL"
echo ""
echo "Useful commands:"
echo "  docker logs $CONTAINER_NAME"
echo "  docker stop $CONTAINER_NAME"
echo "  docker restart $CONTAINER_NAME"

# Wait a moment and test if it's working
sleep 3
if curl -f http://localhost:$HOST_PORT/health >/dev/null 2>&1; then
    echo -e "${GREEN}🎉 Health check passed! Frontend is ready.${NC}"
else
    echo -e "${YELLOW}⚠️  Health check failed. Container might still be starting.${NC}"
fi
