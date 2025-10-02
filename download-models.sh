#!/bin/bash

# LocalAI Model Download Script
# This script helps download popular models for LocalAI

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}====================================${NC}"
    echo -e "${BLUE}      LocalAI Model Downloader      ${NC}"
    echo -e "${BLUE}====================================${NC}"
    echo
}

download_model() {
    local model_name="$1"
    local model_url="$2"
    local model_file="$3"
    
    echo -e "${BLUE}Downloading $model_name...${NC}"
    
    if [ -f "models/$model_file" ]; then
        echo -e "${YELLOW}Model already exists: models/$model_file${NC}"
        read -p "Overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Skipping $model_name${NC}"
            return
        fi
    fi
    
    mkdir -p models
    
    if wget -q --show-progress "$model_url" -O "models/$model_file"; then
        echo -e "${GREEN}Successfully downloaded: $model_name${NC}"
    else
        echo -e "${RED}Failed to download: $model_name${NC}"
        rm -f "models/$model_file"
    fi
    echo
}

show_menu() {
    echo "Available models to download:"
    echo "1) Phi-2 (2.7B parameters, ~2.5GB) - Small, fast text generation"
    echo "2) Whisper Base (~140MB) - Speech recognition"
    echo "3) TinyLlama-1.1B (~637MB) - Very small text generation"
    echo "4) Code Llama 7B Instruct (~4GB) - Code generation"
    echo "5) All recommended models"
    echo "0) Exit"
    echo
}

print_header

if [ ! -d "models" ]; then
    mkdir -p models
fi

while true; do
    show_menu
    read -p "Select a model to download (0-5): " choice
    
    case $choice in
        1)
            download_model "Phi-2" \
                "https://huggingface.co/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q8_0.gguf" \
                "phi-2.Q8_0.gguf"
            ;;
        2)
            download_model "Whisper Base" \
                "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin" \
                "ggml-base.bin"
            ;;
        3)
            download_model "TinyLlama-1.1B" \
                "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q8_0.gguf" \
                "tinyllama-1.1b-chat-v1.0.Q8_0.gguf"
            ;;
        4)
            download_model "Code Llama 7B Instruct" \
                "https://huggingface.co/TheBloke/CodeLlama-7B-Instruct-GGUF/resolve/main/codellama-7b-instruct.Q4_K_M.gguf" \
                "codellama-7b-instruct.Q4_K_M.gguf"
            ;;
        5)
            echo -e "${BLUE}Downloading all recommended models...${NC}"
            download_model "Phi-2" \
                "https://huggingface.co/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q8_0.gguf" \
                "phi-2.Q8_0.gguf"
            download_model "Whisper Base" \
                "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin" \
                "ggml-base.bin"
            download_model "TinyLlama-1.1B" \
                "https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q8_0.gguf" \
                "tinyllama-1.1b-chat-v1.0.Q8_0.gguf"
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            break
            ;;
        *)
            echo -e "${RED}Invalid option. Please select 0-5.${NC}"
            ;;
    esac
done

echo -e "${GREEN}Model download complete!${NC}"
echo -e "${YELLOW}Restart LocalAI to load new models: make stop && make start${NC}"