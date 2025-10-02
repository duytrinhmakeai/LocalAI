#!/bin/bash

# LocalAI Monitoring Script
# This script monitors LocalAI services and provides system information

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}==================================${NC}"
    echo -e "${BLUE}      LocalAI System Monitor      ${NC}"
    echo -e "${BLUE}==================================${NC}"
    echo
}

check_service_status() {
    echo -e "${BLUE}Service Status:${NC}"
    
    if docker-compose ps | grep -q "localai.*Up"; then
        echo -e "  LocalAI: ${GREEN}Running${NC}"
    else
        echo -e "  LocalAI: ${RED}Stopped${NC}"
    fi
    echo
}

check_api_health() {
    echo -e "${BLUE}API Health Check:${NC}"
    
    if curl -s -f http://localhost:8080/readyz > /dev/null 2>&1; then
        echo -e "  API Endpoint: ${GREEN}Healthy${NC}"
    else
        echo -e "  API Endpoint: ${RED}Unhealthy${NC}"
    fi
    
    if curl -s -f http://localhost:8080/v1/models > /dev/null 2>&1; then
        echo -e "  Models API: ${GREEN}Available${NC}"
        MODEL_COUNT=$(curl -s http://localhost:8080/v1/models 2>/dev/null | jq -r '.data | length' 2>/dev/null || echo "0")
        echo -e "  Models Loaded: ${GREEN}$MODEL_COUNT${NC}"
    else
        echo -e "  Models API: ${RED}Unavailable${NC}"
    fi
    echo
}

check_resources() {
    echo -e "${BLUE}Resource Usage:${NC}"
    
    # Docker container stats
    if docker ps | grep -q localai; then
        CONTAINER_ID=$(docker ps --filter name=localai --format "{{.ID}}" | head -1)
        if [ ! -z "$CONTAINER_ID" ]; then
            STATS=$(docker stats --no-stream --format "table {{.CPUPerc}}\t{{.MemUsage}}" $CONTAINER_ID | tail -1)
            echo -e "  Container CPU: ${GREEN}$(echo $STATS | awk '{print $1}')${NC}"
            echo -e "  Container Memory: ${GREEN}$(echo $STATS | awk '{print $2}')${NC}"
        fi
    fi
    
    # Disk usage
    MODELS_SIZE=$(du -sh models/ 2>/dev/null | awk '{print $1}' || echo "0B")
    BACKENDS_SIZE=$(du -sh backends/ 2>/dev/null | awk '{print $1}' || echo "0B")
    echo -e "  Models Directory: ${GREEN}$MODELS_SIZE${NC}"
    echo -e "  Backends Directory: ${GREEN}$BACKENDS_SIZE${NC}"
    echo
}

show_logs() {
    echo -e "${BLUE}Recent Logs (last 20 lines):${NC}"
    docker-compose logs --tail=20 localai 2>/dev/null || echo "No logs available"
    echo
}

show_models() {
    echo -e "${BLUE}Available Models:${NC}"
    if [ -d "models" ] && [ "$(ls -A models/)" ]; then
        ls -la models/ | grep -v "^total" | grep -v "^d" | awk '{print "  " $9 " (" $5 " bytes)"}'  | grep -v "^  $"
    else
        echo "  No models found in models/ directory"
    fi
    echo
}

# Main execution
print_header
check_service_status
check_api_health
check_resources
show_models

if [ "$1" = "--logs" ]; then
    show_logs
fi

echo -e "${GREEN}Monitoring complete!${NC}"
echo -e "${YELLOW}Use './monitor.sh --logs' to see recent logs${NC}"