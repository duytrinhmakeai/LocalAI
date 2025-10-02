# LocalAI Quick Start Guide

This guide will help you get LocalAI up and running in minutes.

## Step 1: Install Docker

If you don't have Docker installed:

### Linux
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
# Log out and back in for group changes to take effect
```

### macOS
Download and install [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)

### Windows
Download and install [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)

## Step 2: Run Installation

```bash
# Make scripts executable
chmod +x *.sh

# Run installation
./install.sh
```

## Step 3: Download a Model (Optional)

LocalAI can auto-download models, but you can pre-download for faster startup:

```bash
./download-models.sh
```

Select option 3 for TinyLlama (smallest, fastest) or option 1 for Phi-2 (better quality).

## Step 4: Start LocalAI

### Using Make (Recommended)
```bash
# CPU version
make start

# GPU version (if you have NVIDIA GPU)
make start-gpu
```

### Using Start Script
```bash
# Interactive mode
./start.sh

# With GPU
./start.sh --gpu

# In foreground (see logs immediately)
./start.sh --foreground
```

### Using Docker Compose
```bash
# CPU
docker-compose up -d

# GPU
docker-compose -f docker-compose.gpu.yaml up -d
```

## Step 5: Verify Installation

Wait 30-60 seconds for LocalAI to start, then check:

```bash
# Check if running
docker ps | grep localai

# Check health
curl http://localhost:8080/readyz

# List models
curl http://localhost:8080/v1/models
```

## Step 6: Access LocalAI

Open your browser and go to:
- **WebUI**: http://localhost:8080

Or use the API:
```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-2.Q8_0.gguf",
    "messages": [
      {"role": "user", "content": "Say hello!"}
    ]
  }'
```

## Step 7: Monitor System

```bash
# Check system status
./monitor.sh

# View logs
make logs
# or
docker-compose logs -f
```

## Common Commands

```bash
make start       # Start LocalAI
make stop        # Stop LocalAI
make logs        # View logs
make models      # List models
./monitor.sh     # System health check
```

## Troubleshooting

### "Docker not found"
Install Docker first (see Step 1)

### "Permission denied"
```bash
chmod +x *.sh
```

### "Port 8080 already in use"
Edit `.env` and change `PORT=8080` to another port like `PORT=8081`

### "Out of memory"
- Use smaller models (TinyLlama instead of larger models)
- Reduce `CONTEXT_SIZE` in `.env`
- Close other applications

### "Model not loading"
- Check if model file exists: `ls -la models/`
- Restart: `make stop && make start`
- Check logs: `make logs`

## Next Steps

1. **Explore the WebUI** at http://localhost:8080
2. **Read the full README.md** for advanced features
3. **Try the API examples** in README.md
4. **Download more models** from the model gallery
5. **Configure custom models** in `configuration/models.yaml`

## Getting Help

- Check `./monitor.sh` for system status
- View logs with `make logs`
- Read the [LocalAI Documentation](https://localai.io/)
- Join the [Discord Community](https://discord.gg/uJAeKSAGDy)

---

**You're all set! Enjoy using LocalAI! 🚀**
