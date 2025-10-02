#!/bin/bash

# LocalAI Installation Script
# This script sets up LocalAI with Docker Compose

set -e

echo "🚀 Installing LocalAI..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "   Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p models backends gallery configuration

# Set permissions
chmod 755 models backends gallery configuration

# Pull the latest LocalAI image
echo "🐳 Pulling LocalAI Docker image..."
docker pull localai/localai:latest

echo "✅ LocalAI installation completed!"
echo ""
echo "📋 Next steps:"
echo "   1. Place your models in the 'models' directory"
echo "   2. Run 'docker-compose up -d' to start LocalAI"
echo "   3. Access the WebUI at http://localhost:8080"
echo "   4. For GPU support, use 'docker-compose -f docker-compose.gpu.yaml up -d'"
echo ""
echo "📖 For more information, check the README.md file"