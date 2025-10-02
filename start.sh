#!/bin/bash

# LocalAI Startup Script
# This script provides an easy way to start LocalAI with different configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}      LocalAI Startup Script    ${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Parse command line arguments
GPU_SUPPORT=false
FORCE_REBUILD=false
DETACHED=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --gpu)
            GPU_SUPPORT=true
            shift
            ;;
        --rebuild)
            FORCE_REBUILD=true
            shift
            ;;
        --foreground)
            DETACHED=false
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --gpu         Enable GPU support (NVIDIA)"
            echo "  --rebuild     Force rebuild of containers"
            echo "  --foreground  Run in foreground (don't detach)"
            echo "  --help        Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

print_header

# Check prerequisites
print_status "Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
print_status "Creating directories..."
mkdir -p models backends gallery configuration

# Choose compose file
if [ "$GPU_SUPPORT" = true ]; then
    COMPOSE_FILE="docker-compose.gpu.yaml"
    print_status "Starting LocalAI with GPU support..."
else
    COMPOSE_FILE="docker-compose.yaml"
    print_status "Starting LocalAI with CPU support..."
fi

# Build options
BUILD_OPTS=""
RUN_OPTS=""

if [ "$FORCE_REBUILD" = true ]; then
    BUILD_OPTS="--build --force-recreate"
    print_status "Force rebuilding containers..."
fi

if [ "$DETACHED" = true ]; then
    RUN_OPTS="-d"
fi

# Start LocalAI
print_status "Starting LocalAI services..."

if [ "$DETACHED" = true ]; then
    docker-compose -f "$COMPOSE_FILE" up $BUILD_OPTS $RUN_OPTS
    
    print_status "LocalAI is starting up..."
    print_status "WebUI will be available at: http://localhost:8080"
    print_status "API endpoint: http://localhost:8080/v1"
    print_status "Health check: http://localhost:8080/readyz"
    
    print_status "Use 'docker-compose logs -f' to view logs"
    print_status "Use 'docker-compose down' to stop services"
else
    print_status "Running in foreground mode (Ctrl+C to stop)..."
    docker-compose -f "$COMPOSE_FILE" up $BUILD_OPTS
fi

print_status "Done!"