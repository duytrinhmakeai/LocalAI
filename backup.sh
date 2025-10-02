#!/bin/bash

# LocalAI Backup and Restore Script
# This script creates backups of LocalAI configuration and models

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="localai_backup_$TIMESTAMP"

print_header() {
    echo -e "${BLUE}===================================${NC}"
    echo -e "${BLUE}     LocalAI Backup & Restore      ${NC}"
    echo -e "${BLUE}===================================${NC}"
    echo
}

create_backup() {
    echo -e "${BLUE}Creating backup: $BACKUP_NAME${NC}"
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR/$BACKUP_NAME"
    
    # Backup configuration files
    if [ -d "configuration" ]; then
        echo "Backing up configuration..."
        cp -r configuration "$BACKUP_DIR/$BACKUP_NAME/"
    fi
    
    # Backup gallery
    if [ -d "gallery" ]; then
        echo "Backing up gallery..."
        cp -r gallery "$BACKUP_DIR/$BACKUP_NAME/"
    fi
    
    # Backup docker compose files
    echo "Backing up Docker Compose files..."
    cp docker-compose*.yaml "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
    cp .env "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
    cp Dockerfile* "$BACKUP_DIR/$BACKUP_NAME/" 2>/dev/null || true
    
    # Create models list (don't backup actual models due to size)
    if [ -d "models" ]; then
        echo "Creating models inventory..."
        ls -la models/ > "$BACKUP_DIR/$BACKUP_NAME/models_inventory.txt" 2>/dev/null || true
    fi
    
    # Create archive
    echo "Creating compressed archive..."
    cd "$BACKUP_DIR"
    tar -czf "$BACKUP_NAME.tar.gz" "$BACKUP_NAME"
    rm -rf "$BACKUP_NAME"
    cd - > /dev/null
    
    echo -e "${GREEN}Backup created successfully: $BACKUP_DIR/$BACKUP_NAME.tar.gz${NC}"
    echo
}

list_backups() {
    echo -e "${BLUE}Available backups:${NC}"
    
    if [ -d "$BACKUP_DIR" ] && [ "$(ls -A $BACKUP_DIR/*.tar.gz 2>/dev/null)" ]; then
        ls -la "$BACKUP_DIR"/*.tar.gz | awk '{print "  " $9 " (" $5 " bytes, " $6 " " $7 " " $8 ")"}'
    else
        echo "  No backups found"
    fi
    echo
}

restore_backup() {
    local backup_file="$1"
    
    if [ ! -f "$backup_file" ]; then
        echo -e "${RED}Backup file not found: $backup_file${NC}"
        return 1
    fi
    
    echo -e "${YELLOW}WARNING: This will overwrite existing configuration!${NC}"
    read -p "Continue with restore? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Restore cancelled${NC}"
        return
    fi
    
    echo -e "${BLUE}Restoring from: $backup_file${NC}"
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    
    # Extract backup
    tar -xzf "$backup_file" -C "$TEMP_DIR"
    
    # Find the backup directory
    BACKUP_CONTENT=$(find "$TEMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -1)
    
    if [ -z "$BACKUP_CONTENT" ]; then
        echo -e "${RED}Invalid backup file${NC}"
        rm -rf "$TEMP_DIR"
        return 1
    fi
    
    # Restore files
    if [ -d "$BACKUP_CONTENT/configuration" ]; then
        echo "Restoring configuration..."
        rm -rf configuration
        cp -r "$BACKUP_CONTENT/configuration" .
    fi
    
    if [ -d "$BACKUP_CONTENT/gallery" ]; then
        echo "Restoring gallery..."
        rm -rf gallery
        cp -r "$BACKUP_CONTENT/gallery" .
    fi
    
    # Restore compose files
    cp "$BACKUP_CONTENT"/*.yaml . 2>/dev/null || true
    cp "$BACKUP_CONTENT"/.env . 2>/dev/null || true
    cp "$BACKUP_CONTENT"/Dockerfile* . 2>/dev/null || true
    
    # Show models inventory
    if [ -f "$BACKUP_CONTENT/models_inventory.txt" ]; then
        echo -e "${BLUE}Models that were in the backup:${NC}"
        cat "$BACKUP_CONTENT/models_inventory.txt"
        echo
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    echo -e "${GREEN}Restore completed successfully!${NC}"
    echo -e "${YELLOW}Remember to restart LocalAI: make stop && make start${NC}"
    echo
}

show_usage() {
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo
    echo "Commands:"
    echo "  backup          Create a new backup"
    echo "  list            List available backups"
    echo "  restore [FILE]  Restore from backup file"
    echo "  help            Show this help message"
    echo
}

# Main execution
print_header

case "${1:-help}" in
    backup)
        create_backup
        ;;
    list)
        list_backups
        ;;
    restore)
        if [ -z "$2" ]; then
            echo -e "${RED}Please specify backup file to restore${NC}"
            list_backups
        else
            restore_backup "$2"
        fi
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        show_usage
        exit 1
        ;;
esac