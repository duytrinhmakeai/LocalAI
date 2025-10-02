# 🚀 LocalAI - Hướng Dẫn Triển Khai (Tiếng Việt)

## 📋 Tổng Quan

Dự án này triển khai **LocalAI** - một giải pháp thay thế mã nguồn mở, miễn phí cho OpenAI, chạy hoàn toàn trên máy tính cá nhân của bạn.

### ✅ Trạng Thái Dự Án: HOÀN THÀNH

Tất cả các thành phần đã được thiết lập và sẵn sàng sử dụng!

## 🎯 Tính Năng Chính

- 🤖 **Tạo văn bản** - API tương thích với GPT
- 🎨 **Tạo hình ảnh** - Stable Diffusion, FLUX.1
- 🔊 **Chuyển văn bản thành giọng nói** (TTS)
- 🎤 **Chuyển giọng nói thành văn bản** (STT) - Whisper
- 🧠 **Embeddings** - Cho ứng dụng RAG
- 🔍 **Nhận diện đối tượng**
- 🌐 **Giao diện Web** tích hợp
- 🚀 **Tăng tốc GPU** - CUDA, ROCm, Intel, Metal
- 🔒 **Bảo mật** - Mọi thứ chạy local, không chia sẻ dữ liệu

## 📁 Cấu Trúc Dự Án

```
LocalAI/
├── 📋 File cấu hình Docker
│   ├── docker-compose.yaml         # Cấu hình CPU
│   ├── docker-compose.gpu.yaml     # Cấu hình GPU
│   ├── docker-compose.dev.yaml     # Chế độ phát triển
│   ├── .env                        # Biến môi trường
│   └── Dockerfile, Dockerfile.dev
│
├── ⚙️ Thư mục cấu hình
│   ├── models.yaml                 # Cấu hình model
│   ├── api_keys.json              # Quản lý API key
│   ├── external_backends.json     # API bên ngoài
│   └── galleries.yaml             # Thư viện model
│
├── 🛠️ Scripts tiện ích
│   ├── install.sh                 # Cài đặt tự động
│   ├── start.sh                   # Khởi động thông minh
│   ├── monitor.sh                 # Giám sát hệ thống
│   ├── download-models.sh         # Tải model
│   └── backup.sh                  # Sao lưu/khôi phục
│
├── 📚 Tài liệu
│   ├── README.md                  # Tài liệu đầy đủ (English)
│   ├── README.vi.md              # Tài liệu này (Tiếng Việt)
│   ├── QUICKSTART.md             # Hướng dẫn nhanh
│   └── PROJECT_SUMMARY.md        # Tổng quan dự án
│
└── 📁 Thư mục chính
    ├── models/                    # Chứa file model AI
    ├── backends/                  # Backend executables
    ├── gallery/                   # Thư viện model local
    └── configuration/             # File cấu hình
```

## 🚀 Hướng Dẫn Cài Đặt

### Bước 1: Cài Đặt Docker

**Docker là bắt buộc để chạy LocalAI!**

#### Linux (Ubuntu/Debian)
```bash
# Cài đặt Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Thêm user vào group docker
sudo usermod -aG docker $USER

# Đăng xuất và đăng nhập lại để áp dụng thay đổi
```

#### macOS
Tải và cài đặt [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/)

#### Windows
Tải và cài đặt [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)

### Bước 2: Chạy Script Cài Đặt

```bash
# Cấp quyền thực thi cho các script
chmod +x *.sh

# Chạy cài đặt
./install.sh
```

### Bước 3: Tải Model (Tùy chọn)

LocalAI có thể tự động tải model, nhưng bạn có thể tải trước để khởi động nhanh hơn:

```bash
./download-models.sh
```

**Các model được đề xuất:**
- **TinyLlama-1.1B** (~637MB) - Nhỏ, nhanh
- **Phi-2** (~2.5GB) - Cân bằng hiệu suất
- **Whisper Base** (~140MB) - Nhận dạng giọng nói
- **Code Llama 7B** (~4GB) - Tạo code

### Bước 4: Khởi Động LocalAI

#### Sử dụng Make (Khuyên dùng)
```bash
# Khởi động với CPU
make start

# Khởi động với GPU (NVIDIA)
make start-gpu

# Xem log
make logs

# Dừng dịch vụ
make stop
```

#### Sử dụng Script
```bash
# Khởi động bình thường
./start.sh

# Khởi động với GPU
./start.sh --gpu

# Chạy ở foreground (xem log trực tiếp)
./start.sh --foreground
```

#### Sử dụng Docker Compose
```bash
# CPU
docker-compose up -d

# GPU
docker-compose -f docker-compose.gpu.yaml up -d
```

#### Sử dụng VS Code Tasks
1. Nhấn `Ctrl+Shift+P` (hoặc `Cmd+Shift+P` trên Mac)
2. Gõ "Run Task"
3. Chọn task:
   - **LocalAI: Install and Setup**
   - **LocalAI: Start (CPU)**
   - **LocalAI: Start (GPU)**
   - **LocalAI: View Logs**
   - **LocalAI: System Monitor**

### Bước 5: Kiểm Tra Hệ Thống

```bash
# Kiểm tra dịch vụ đang chạy
docker ps | grep localai

# Kiểm tra sức khỏe
curl http://localhost:8080/readyz

# Liệt kê model
curl http://localhost:8080/v1/models

# Hoặc sử dụng script giám sát
./monitor.sh
```

### Bước 6: Truy Cập LocalAI

Sau khi khởi động (chờ 30-60 giây):

- **Giao diện Web**: http://localhost:8080
- **API Endpoint**: http://localhost:8080/v1
- **Health Check**: http://localhost:8080/readyz
- **Swagger API**: http://localhost:8080/swagger

## 📝 Các Lệnh Thường Dùng

### Sử dụng Make
```bash
make help         # Hiển thị tất cả lệnh
make install      # Cài đặt và thiết lập
make start        # Khởi động (CPU)
make start-gpu    # Khởi động (GPU)
make stop         # Dừng dịch vụ
make logs         # Xem log
make models       # Liệt kê model
make clean        # Dọn dẹp
make build        # Build image tùy chỉnh
```

### Sử dụng Scripts
```bash
./install.sh                    # Cài đặt
./start.sh [--gpu|--foreground] # Khởi động
./monitor.sh [--logs]           # Giám sát
./download-models.sh            # Tải model
./backup.sh backup              # Sao lưu
./backup.sh list                # Liệt kê backup
./backup.sh restore <file>      # Khôi phục
```

## 🔧 Cấu Hình

### File .env

Chỉnh sửa file `.env` để tùy chỉnh:

```bash
# Hiệu suất
THREADS=4              # Số luồng CPU
CONTEXT_SIZE=2048      # Kích thước context
GPU_LAYERS=0           # Số layer GPU (>0 nếu dùng GPU)

# API
PORT=8080              # Cổng API
API_KEY=               # API key (tùy chọn)

# Backend
SINGLE_ACTIVE_BACKEND=false  # Chỉ load 1 backend
LOW_VRAM=false              # Chế độ VRAM thấp
```

### Cấu Hình Model (configuration/models.yaml)

```yaml
- name: "gpt-4"
  model: "phi-2.Q8_0.gguf"
  backend: "llama-cpp"
  context_size: 2048
  threads: 4
  parameters:
    temperature: 0.7
    top_k: 40
    top_p: 0.95
```

## 🌐 Sử Dụng API

### Chat Completion
```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-2.Q8_0.gguf",
    "messages": [
      {"role": "user", "content": "Xin chào!"}
    ]
  }'
```

### Text Completion
```bash
curl http://localhost:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-2.Q8_0.gguf",
    "prompt": "Ngày xưa có một",
    "max_tokens": 50
  }'
```

### Embeddings
```bash
curl http://localhost:8080/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{
    "model": "bert-embeddings",
    "input": "Câu văn cần tạo embedding"
  }'
```

### Sử dụng với Python
```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="not-needed"
)

response = client.chat.completions.create(
    model="phi-2.Q8_0.gguf",
    messages=[
        {"role": "user", "content": "Xin chào!"}
    ]
)

print(response.choices[0].message.content)
```

## 🐛 Xử Lý Sự Cố

### Dịch vụ không khởi động
```bash
# Kiểm tra Docker
docker ps -a

# Xem log
make logs

# Kiểm tra hệ thống
./monitor.sh
```

### Lỗi hết bộ nhớ
```bash
# Giảm context size trong .env
CONTEXT_SIZE=1024
LOW_VRAM=true

# Sử dụng model nhỏ hơn
# Hoặc bật GPU layers
GPU_LAYERS=35
```

### Model không load
```bash
# Kiểm tra thư mục models
ls -la models/

# Kiểm tra cấu hình
cat configuration/models.yaml

# Khởi động lại
make stop && make start
```

### Port đã được sử dụng
```bash
# Thay đổi port trong .env
PORT=8081

# Hoặc tìm và dừng process
lsof -ti:8080 | xargs kill -9
```

## 📊 Yêu Cầu Hệ Thống

### Tối thiểu
- 8GB RAM
- 4 CPU cores
- 10GB dung lượng trống
- Docker & Docker Compose

### Khuyên dùng
- 16GB+ RAM
- 8+ CPU cores
- 50GB+ dung lượng (cho nhiều model)
- GPU NVIDIA (tùy chọn, để tăng tốc)

## 📚 Tài Liệu Thêm

- **Tài liệu đầy đủ**: README.md (English)
- **Hướng dẫn nhanh**: QUICKSTART.md
- **Tổng quan dự án**: PROJECT_SUMMARY.md
- **Quản lý model**: models/README.md
- **Thông tin backend**: backends/README.md

## 🔗 Tài Nguyên

- **Tài liệu chính thức**: https://localai.io/
- **GitHub**: https://github.com/mudler/LocalAI
- **Model Gallery**: https://models.localai.io/
- **Discord**: https://discord.gg/uJAeKSAGDy

## ✅ Danh Sách Hoàn Thành

- [x] Cấu trúc dự án
- [x] Docker Compose (CPU/GPU/Dev)
- [x] File cấu hình
- [x] Scripts tiện ích
- [x] Makefile
- [x] VS Code tasks
- [x] Extensions (Docker, YAML)
- [x] Tài liệu đầy đủ
- [x] Hướng dẫn tiếng Việt
- [x] .gitignore

## 🎉 Sẵn Sàng Sử Dụng!

Dự án đã hoàn thành và sẵn sàng triển khai!

**Bắt đầu ngay:** `make start` (sau khi cài Docker)

---

**Triển khai hoàn tất:** 01/10/2025  
**Trạng thái:** Sẵn sàng Production ✅
