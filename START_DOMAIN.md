# 🚀 HƯỚNG DẪN KHỞI ĐỘNG LOCALAI VỚI DOMAIN

## Domain: localai.makeai.vn

---

## ⚠️ YÊU CẦU TRƯỚC KHI BẮT ĐẦU

### 1. Cài Đặt Docker

Docker **CHƯA ĐƯỢC CÀI ĐẶT** trên hệ thống này!

```bash
# Cài đặt Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Thêm user vào group docker
sudo usermod -aG docker $USER

# Đăng xuất và đăng nhập lại để áp dụng
# Hoặc chạy:
newgrp docker
```

### 2. Cấu Hình DNS

Trỏ domain `localai.makeai.vn` về IP của server này:

**Tại nhà cung cấp domain:**
- Type: **A Record**
- Name: **localai.makeai.vn** (hoặc **localai** nếu domain gốc là makeai.vn)
- Value: **<IP_PUBLIC_CỦA_SERVER_NÀY>**
- TTL: **Auto** hoặc **300**

**Kiểm tra DNS:**
```bash
nslookup localai.makeai.vn
# hoặc
ping localai.makeai.vn
```

---

## 🎯 KHỞI ĐỘNG HỆ THỐNG

### Sau khi đã có Docker và DNS:

```bash
# Chạy script khởi động
./start-domain.sh
```

Script sẽ tự động:
- ✅ Kiểm tra Docker
- ✅ Tạo thư mục cần thiết
- ✅ Dừng containers cũ (nếu có)
- ✅ Khởi động LocalAI và Nginx
- ✅ Hiển thị thông tin truy cập

---

## 🌐 TRUY CẬP SAU KHI KHỞI ĐỘNG

### Qua Domain (sau khi DNS đã resolve):
- **WebUI**: http://localai.makeai.vn
- **API**: http://localai.makeai.vn/v1
- **Health**: http://localai.makeai.vn/readyz
- **Swagger**: http://localai.makeai.vn/swagger

### Qua Localhost (test ngay):
- **WebUI**: http://localhost
- **API**: http://localhost/v1
- **Health**: http://localhost/readyz

---

## 🔒 CÀI ĐẶT SSL (SAU KHI HỆ THỐNG ĐÃ CHẠY)

### Cách 1: Tự động với Let's Encrypt
```bash
./setup-ssl.sh
```

Script sẽ:
- Cài đặt Certbot
- Tạo SSL certificate miễn phí
- Cập nhật cấu hình Nginx
- Khởi động lại services
- Bật HTTPS tự động

### Cách 2: Thủ công
Xem hướng dẫn chi tiết trong file **DOMAIN_SETUP.md**

---

## 📋 CÁC LỆNH QUAN TRỌNG

### Xem logs
```bash
# Tất cả services
docker-compose -f docker-compose.domain.yaml logs -f

# Chỉ LocalAI
docker-compose -f docker-compose.domain.yaml logs -f localai

# Chỉ Nginx  
docker-compose -f docker-compose.domain.yaml logs -f nginx
```

### Khởi động lại
```bash
docker-compose -f docker-compose.domain.yaml restart
```

### Dừng hệ thống
```bash
docker-compose -f docker-compose.domain.yaml down
```

### Kiểm tra trạng thái
```bash
docker-compose -f docker-compose.domain.yaml ps
```

---

## ✅ CHECKLIST TRIỂN KHAI

### Bước 1: Chuẩn bị
- [ ] Cài đặt Docker (`curl -fsSL https://get.docker.com | sh`)
- [ ] Thêm user vào docker group (`sudo usermod -aG docker $USER`)
- [ ] Đăng xuất và đăng nhập lại

### Bước 2: Cấu hình DNS
- [ ] Trỏ A Record: localai.makeai.vn → IP server
- [ ] Chờ DNS propagate (5-30 phút)
- [ ] Kiểm tra DNS: `nslookup localai.makeai.vn`

### Bước 3: Khởi động
- [ ] Chạy: `./start-domain.sh`
- [ ] Chờ services khởi động (1-2 phút)
- [ ] Kiểm tra: `docker ps`

### Bước 4: Kiểm tra hoạt động
- [ ] Test localhost: `curl http://localhost/readyz`
- [ ] Test domain: `curl http://localai.makeai.vn/readyz`
- [ ] Mở browser: http://localai.makeai.vn

### Bước 5: SSL (Tùy chọn)
- [ ] Chạy: `./setup-ssl.sh`
- [ ] Nhập email khi được hỏi
- [ ] Kiểm tra: https://localai.makeai.vn

### Bước 6: Models
- [ ] Tải models: `./download-models.sh`
- [ ] Hoặc đặt models vào thư mục `models/`
- [ ] Khởi động lại: `docker-compose -f docker-compose.domain.yaml restart localai`

---

## 🧪 TEST API

### Kiểm tra health
```bash
curl http://localai.makeai.vn/readyz
```

### Liệt kê models
```bash
curl http://localai.makeai.vn/v1/models
```

### Chat với AI
```bash
curl http://localai.makeai.vn/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-2.Q8_0.gguf",
    "messages": [
      {"role": "user", "content": "Xin chào!"}
    ]
  }'
```

---

## 🐛 XỬ LÝ SỰ CỐ

### Docker chưa cài đặt
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# Đăng xuất và đăng nhập lại
```

### DNS chưa resolve
- Chờ thêm 5-30 phút
- Kiểm tra cấu hình DNS tại nhà cung cấp
- Test với localhost trước: http://localhost

### Services không khởi động
```bash
# Xem logs
docker-compose -f docker-compose.domain.yaml logs

# Khởi động lại
docker-compose -f docker-compose.domain.yaml restart
```

### Lỗi 502 Bad Gateway
- LocalAI đang khởi động, chờ 2-3 phút
- Kiểm tra: `docker-compose -f docker-compose.domain.yaml logs localai`

### Port 80/443 đã được sử dụng
```bash
# Kiểm tra process nào đang dùng
sudo lsof -i :80
sudo lsof -i :443

# Dừng process cũ hoặc thay đổi port
```

---

## 📞 HỖ TRỢ

### File hướng dẫn:
- **START_DOMAIN.md** (file này) - Hướng dẫn khởi động
- **DOMAIN_SETUP.md** - Hướng dẫn cấu hình chi tiết
- **README.vi.md** - Tài liệu đầy đủ
- **BUILD_REPORT.vi.md** - Báo cáo dự án

### Scripts hỗ trợ:
- `./start-domain.sh` - Khởi động với domain
- `./setup-ssl.sh` - Cài đặt SSL
- `./monitor.sh` - Giám sát hệ thống
- `./download-models.sh` - Tải models

### Lệnh hữu ích:
```bash
# Xem tất cả containers
docker ps -a

# Xem logs chi tiết
docker-compose -f docker-compose.domain.yaml logs -f --tail=100

# Khởi động lại toàn bộ
docker-compose -f docker-compose.domain.yaml down
docker-compose -f docker-compose.domain.yaml up -d

# Kiểm tra resource usage
docker stats
```

---

## 🎉 TỔNG KẾT

### Các file đã tạo cho domain:
- ✅ `docker-compose.domain.yaml` - Docker compose với Nginx
- ✅ `nginx/nginx.conf` - Cấu hình Nginx chính
- ✅ `nginx/conf.d/localai.conf` - Cấu hình domain
- ✅ `start-domain.sh` - Script khởi động
- ✅ `setup-ssl.sh` - Script cài SSL
- ✅ `DOMAIN_SETUP.md` - Hướng dẫn chi tiết
- ✅ `START_DOMAIN.md` - File này

### Cấu trúc hệ thống:
```
Internet
    ↓
DNS (localai.makeai.vn)
    ↓
Server IP (port 80/443)
    ↓
Nginx (reverse proxy)
    ↓
LocalAI (port 8080)
```

---

## 🚀 BẮT ĐẦU NGAY

```bash
# 1. Cài Docker (nếu chưa có)
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# Đăng xuất và đăng nhập lại

# 2. Khởi động
./start-domain.sh

# 3. Truy cập
# http://localai.makeai.vn (sau khi DNS resolve)
# http://localhost (test ngay)

# 4. Cài SSL (tùy chọn)
./setup-ssl.sh
```

---

**Hệ thống đã sẵn sàng! Chỉ cần cài Docker và chạy! 🎊**

**Ngày tạo:** 01/10/2025  
**Domain:** localai.makeai.vn  
**Status:** ✅ Sẵn sàng triển khai
