# Models Directory

This directory contains AI model files for LocalAI.

## Supported Formats
- GGUF (recommended)
- GGML
- Safetensors
- PyTorch models

## Adding Models

1. Download models from:
   - [Hugging Face](https://huggingface.co/models)
   - [Model Gallery](https://models.localai.io/)
   - [TheBloke's GGUF models](https://huggingface.co/TheBloke)

2. Place model files in this directory

3. Restart LocalAI to load new models

## Example Models

```bash
# Download a small model for testing
wget https://huggingface.co/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q8_0.gguf -O models/phi-2.Q8_0.gguf

# Download Whisper for audio
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin -O models/ggml-base.bin
```

## Configuration

Models can be configured in `configuration/models.yaml` with custom parameters, templates, and backends.