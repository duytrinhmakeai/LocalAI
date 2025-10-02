# Backends Directory

This directory contains backend files and configurations for LocalAI.

## Backend Types

LocalAI supports multiple backends:
- **llama.cpp**: C++ implementation for LLMs
- **transformers**: HuggingFace transformers
- **whisper**: Audio transcription
- **diffusers**: Image generation
- **vllm**: Fast LLM inference
- **bark**: Text-to-speech
- **stablediffusion**: Image generation

## Auto-Download

LocalAI automatically downloads required backends when:
1. A model is loaded that requires a specific backend
2. The backend is not already installed
3. The system has internet connectivity

## Manual Backend Installation

```bash
# Using LocalAI CLI (when available)
local-ai backends install llama-cpp
local-ai backends install whisper
local-ai backends install diffusers

# Or place backend files directly in this directory
```

## Backend Configuration

Backends are configured automatically based on:
- Hardware capabilities (CPU, CUDA, ROCm, Intel, Metal)
- Model requirements
- Performance preferences

For advanced configuration, see `configuration/models.yaml`.