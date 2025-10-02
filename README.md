# LocalAI Implementation

> **A free, open-source alternative to OpenAI that runs locally with consumer-grade hardware**

This workspace provides a complete implementation of LocalAI - a drop-in replacement for OpenAI's API that runs entirely on your local machine. No internet required, no data leaves your system.

[![Docker](https://img.shields.io/badge/Docker-Ready-blue)](https://www.docker.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [Configuration](#%EF%B8%8F-configuration)
- [Managing Models](#-managing-models)
- [Available Commands](#-available-commands)
- [Using VS Code Tasks](#-using-vs-code-tasks)
- [API Usage](#-api-usage)
- [Troubleshooting](#-troubleshooting)
- [Advanced Usage](#-advanced-usage)

---

## 🚀 Quick Start

### Prerequisites

- Docker & Docker Compose installed ([Install Docker](https://docs.docker.com/get-docker/))
- At least 8GB RAM (16GB+ recommended)
- 10GB+ free disk space for models

### Installation

```bash
# 1. Run the installation script
./install.sh

# Or manually:
make install
```

### Start LocalAI

```bash
# CPU version (default)
make start

# GPU version (NVIDIA CUDA)
make start-gpu

# Using Docker Compose directly
docker-compose up -d                        # CPU
docker-compose -f docker-compose.gpu.yaml up -d  # GPU
```

### Access LocalAI

Once started, access LocalAI at:

- **WebUI**: http://localhost:8080
- **API Endpoint**: http://localhost:8080/v1
- **Health Check**: http://localhost:8080/readyz
- **API Documentation**: http://localhost:8080/swagger

### First Steps

1. **Download a model** (optional - LocalAI can auto-download):
   ```bash
   ./download-models.sh
   ```

2. **Test the API**:
   ```bash
   curl http://localhost:8080/v1/models
   ```

3. **Generate text**:
   ```bash
   curl http://localhost:8080/v1/completions \
     -H "Content-Type: application/json" \
     -d '{
       "model": "phi-2.Q8_0.gguf",
       "prompt": "Once upon a time",
       "max_tokens": 50
     }'
   ```

---

## ✨ Features

| Feature | Description |
|---------|-------------|
| 🤖 **Text Generation** | GPT-compatible chat and completion endpoints |
| 🎨 **Image Generation** | Stable Diffusion, FLUX.1, and more |
| 🔊 **Text-to-Speech** | Multiple TTS backends (Piper, Coqui, Bark) |
| 🎤 **Speech-to-Text** | Whisper integration for transcription |
| 🧠 **Embeddings** | Vector embeddings for RAG applications |
| 🔍 **Object Detection** | Real-time object detection in images |
| 📊 **Reranking** | Document reranking for search |
| 🌐 **WebUI** | Built-in web interface for easy interaction |
| 🚀 **GPU Acceleration** | CUDA, ROCm, Intel, Metal support |
| 🔧 **Multiple Backends** | llama.cpp, transformers, vllm, and more |
| 🌍 **P2P Mode** | Distributed inference capabilities |
| 🔒 **Privacy First** | Everything runs locally, no data sharing |

---

## 📁 Project Structure

```
LocalAI/
├── .github/
│   └── copilot-instructions.md    # GitHub Copilot instructions
├── .vscode/
│   └── tasks.json                 # VS Code tasks
├── backends/                      # Backend executables (auto-downloaded)
│   └── README.md
├── configuration/                 # Configuration files
│   ├── api_keys.json             # API key management
│   ├── external_backends.json    # External API integrations
│   ├── galleries.yaml            # Model gallery sources
│   └── models.yaml               # Model configurations
├── gallery/                       # Local model gallery
│   └── index.yaml                # Model definitions
├── models/                        # Model files (.gguf, .ggml, etc.)
│   └── README.md
├── .env                          # Environment variables
├── backup.sh                     # Backup/restore script
├── docker-compose.dev.yaml       # Development configuration
├── docker-compose.gpu.yaml       # GPU configuration
├── docker-compose.yaml           # CPU configuration (default)
├── Dockerfile                    # Custom image build
├── Dockerfile.dev                # Development Dockerfile
├── download-models.sh            # Model download utility
├── install.sh                    # Installation script
├── Makefile                      # Build automation
├── monitor.sh                    # System monitoring
├── start.sh                      # Smart startup script
└── README.md                     # This file
```

---

## ⚙️ Configuration

### Environment Variables (`.env`)

Key configuration options:

```bash
# Performance
THREADS=4                    # CPU threads to use
CONTEXT_SIZE=2048           # Maximum context window
GPU_LAYERS=0                # GPU layers (set > 0 for GPU)

# API Settings
PORT=8080                   # API port
API_KEY=                    # Optional API key
ADDRESS=:8080              # Bind address

# Backend
SINGLE_ACTIVE_BACKEND=false # Load one backend at a time
LOW_VRAM=false             # Enable low VRAM mode

# Paths
MODELS_PATH=./models
BACKENDS_PATH=./backends
```

### Model Configuration (`configuration/models.yaml`)

Define custom model settings:

```yaml
- name: "gpt-4"           # API name
  model: "phi-2.Q8_0.gguf"  # Model file
  backend: "llama-cpp"      # Backend to use
  context_size: 4096
  threads: 8
  parameters:
    temperature: 0.7
    top_k: 40
    top_p: 0.95
```

---

## 📦 Managing Models

### Download Models

Using the interactive script:
```bash
./download-models.sh
```

Manually download from Hugging Face:
```bash
# Example: Download Phi-2 model
wget https://huggingface.co/TheBloke/phi-2-GGUF/resolve/main/phi-2.Q8_0.gguf \
  -O models/phi-2.Q8_0.gguf
```

### Recommended Models

| Model | Size | Use Case | Command |
|-------|------|----------|---------|
| TinyLlama-1.1B | ~637MB | Fast responses | `./download-models.sh` → Option 3 |
| Phi-2 | ~2.5GB | Balanced performance | `./download-models.sh` → Option 1 |
| Whisper Base | ~140MB | Speech recognition | `./download-models.sh` → Option 2 |
| Code Llama 7B | ~4GB | Code generation | `./download-models.sh` → Option 4 |

### Model Formats

Supported formats:
- **GGUF** (recommended) - Quantized, efficient
- **GGML** - Legacy format
- **Safetensors** - HuggingFace format
- **PyTorch** - Standard PyTorch models

---

## 🛠️ Available Commands

### Using Make

```bash
make help        # Show all available commands
make install     # Install and setup LocalAI
make start       # Start LocalAI (CPU)
make start-gpu   # Start LocalAI (GPU)
make stop        # Stop all services
make logs        # View live logs
make models      # List installed models
make clean       # Clean up containers and images
make build       # Build custom Docker image
```

### Using Scripts

```bash
./install.sh                 # Install LocalAI
./start.sh                   # Interactive startup
./start.sh --gpu            # Start with GPU support
./start.sh --foreground     # Run in foreground
./monitor.sh                # System health check
./monitor.sh --logs         # Show recent logs
./download-models.sh        # Download models
./backup.sh backup          # Create backup
./backup.sh list           # List backups
./backup.sh restore <file> # Restore from backup
```

---

## 🎯 Using VS Code Tasks

Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) and type "Run Task", then select:

- **LocalAI: Install and Setup** - Initial installation
- **LocalAI: Start (CPU)** - Start with CPU
- **LocalAI: Start (GPU)** - Start with GPU support
- **LocalAI: Stop** - Stop all services
- **LocalAI: View Logs** - Live log monitoring
- **LocalAI: System Monitor** - Health check and stats
- **LocalAI: Download Models** - Interactive model download
- **LocalAI: List Models** - Show installed models
- **LocalAI: Backup Configuration** - Create backup
- **LocalAI: Clean and Reset** - Full cleanup

---

## � API Usage

### OpenAI-Compatible Endpoints

LocalAI implements OpenAI's API, so existing tools work seamlessly:

#### Chat Completions
```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-2.Q8_0.gguf",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

#### Text Completions
```bash
curl http://localhost:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-2.Q8_0.gguf",
    "prompt": "Write a haiku about",
    "max_tokens": 50
  }'
```

#### Embeddings
```bash
curl http://localhost:8080/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{
    "model": "bert-embeddings",
    "input": "The quick brown fox"
  }'
```

#### Image Generation
```bash
curl http://localhost:8080/v1/images/generations \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "A beautiful sunset over mountains",
    "size": "512x512"
  }'
```

#### Speech to Text
```bash
curl http://localhost:8080/v1/audio/transcriptions \
  -F file="@audio.mp3" \
  -F model="whisper-base"
```

---

## � Troubleshooting

### Common Issues

**Service won't start**
```bash
# Check Docker status
docker ps -a

# View logs
make logs

# Check system resources
./monitor.sh
```

**Out of memory errors**
```bash
# Reduce context size in .env
CONTEXT_SIZE=1024
LOW_VRAM=true

# Use smaller models
# Or enable GPU layers
GPU_LAYERS=35
```

**Models not loading**
```bash
# Verify models directory
ls -la models/

# Check model configuration
cat configuration/models.yaml

# Restart services
make stop && make start
```

**Port already in use**
```bash
# Change port in .env
PORT=8081

# Or find and kill existing process
lsof -ti:8080 | xargs kill -9
```

---

## 🚀 Advanced Usage

### Custom Model Configurations

Create advanced model configs in `configuration/models.yaml`:

```yaml
- name: "custom-gpt"
  model: "my-model.gguf"
  backend: "llama-cpp"
  context_size: 8192
  threads: 8
  gpu_layers: 35
  parameters:
    temperature: 0.7
    top_k: 40
    top_p: 0.95
    repeat_penalty: 1.1
  template:
    chat: |
      {{range .Messages}}
      {{if eq .Role "user"}}User: {{.Content}}{{end}}
      {{if eq .Role "assistant"}}Assistant: {{.Content}}{{end}}
      {{end}}
      Assistant:
```

### Using with Python (OpenAI SDK)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="not-needed"
)

response = client.chat.completions.create(
    model="phi-2.Q8_0.gguf",
    messages=[
        {"role": "user", "content": "Hello!"}
    ]
)

print(response.choices[0].message.content)
```

### GPU Acceleration

For NVIDIA GPUs:
```bash
# Set GPU layers in .env
GPU_LAYERS=35

# Start with GPU support
make start-gpu
```

For AMD GPUs (ROCm):
```bash
docker-compose -f docker-compose.gpu.yaml up -d
# Edit docker-compose.gpu.yaml to use ROCm image
```

### Development Mode

```bash
# Use development compose file
docker-compose -f docker-compose.dev.yaml up

# With hot reload and debugging enabled
```

---

## 📚 Resources

- **Official Documentation**: [localai.io](https://localai.io/)
- **GitHub Repository**: [github.com/mudler/LocalAI](https://github.com/mudler/LocalAI)
- **Model Gallery**: [models.localai.io](https://models.localai.io/)
- **Discord Community**: [discord.gg/uJAeKSAGDy](https://discord.gg/uJAeKSAGDy)
- **Examples**: [github.com/mudler/LocalAI-examples](https://github.com/mudler/LocalAI-examples)

---

## 📄 License

This workspace implementation is provided as-is. LocalAI itself is licensed under MIT.

---

## 🤝 Contributing

Contributions are welcome! Please check the [LocalAI GitHub repository](https://github.com/mudler/LocalAI) for contribution guidelines.

---

**Made with ❤️ for the local AI community**
