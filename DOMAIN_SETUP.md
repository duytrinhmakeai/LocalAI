# 🌐 Hướng Dẫn Cấu Hình Domain cho LocalAI

## Domain: localai.makeai.vn

---

## 📋 Bước 1: Cấu Hình DNS

Bạn cần trỏ domain `localai.makeai.vn` về IP của server này.

### Tại nhà cung cấp domain (VD: CloudFlare, GoDaddy, etc):

Thêm **A Record**:
```
Type: A
Name: localai.makeai.vn (hoặc localai nếu domain gốc là makeai.vn)
Value: <IP_PUBLIC_CỦA_SERVER>
TTL: Auto hoặc 300
Proxy: Tắt (cho lần đầu test)
```

### Kiểm tra DNS đã resolve chưa:
```bash
# Kiểm tra DNS
nslookup localai.makeai.vn

# Hoặc
dig localai.makeai.vn

# Hoặc
ping localai.makeai.vn
```

---

## 🚀 Bước 2: Khởi Động LocalAI với Domain

### Cách 1: Sử dụng script (Khuyên dùng)
```bash
./start-domain.sh
```

### Cách 2: Sử dụng Docker Compose trực tiếp
```bash
docker-compose -f docker-compose.domain.yaml up -d
```

---

## 🌐 Bước 3: Truy Cập LocalAI

Sau khi khởi động và DNS đã resolve:

- **WebUI**: http://localai.makeai.vn
- **API Endpoint**: http://localai.makeai.vn/v1
- **Health Check**: http://localai.makeai.vn/readyz
- **Swagger UI**: http://localai.makeai.vn/swagger

### Test từ máy local:
```bash
# Kiểm tra health
curl http://localai.makeai.vn/readyz

# Liệt kê models
curl http://localai.makeai.vn/v1/models

# Chat với AI
curl http://localai.makeai.vn/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "phi-2.Q8_0.gguf",
    "messages": [{"role": "user", "content": "Xin chào!"}]
  }'
```

---

## 🔒 Bước 4: Cấu Hình HTTPS (Tùy chọn nhưng khuyên dùng)

### Option 1: Sử dụng Let's Encrypt (Miễn phí)

```bash
# Cài đặt Certbot
sudo apt install certbot python3-certbot-nginx

# Tạo certificate
sudo certbot certonly --standalone \
  -d localai.makeai.vn \
  --email your-email@example.com \
  --agree-tos

# Certificates sẽ được tạo tại:
# /etc/letsencrypt/live/localai.makeai.vn/fullchain.pem
# /etc/letsencrypt/live/localai.makeai.vn/privkey.pem

# Copy certificates vào nginx/ssl/
sudo cp /etc/letsencrypt/live/localai.makeai.vn/fullchain.pem nginx/ssl/localai.makeai.vn.crt
sudo cp /etc/letsencrypt/live/localai.makeai.vn/privkey.pem nginx/ssl/localai.makeai.vn.key
```

### Option 2: Sử dụng CloudFlare SSL

Nếu dùng CloudFlare:
1. Vào CloudFlare Dashboard
2. SSL/TLS → Origin Server
3. Create Certificate
4. Copy certificate và private key
5. Lưu vào:
   - `nginx/ssl/localai.makeai.vn.crt`
   - `nginx/ssl/localai.makeai.vn.key`

### Sau khi có SSL certificate:

1. **Mở file cấu hình Nginx**:
   ```bash
   nano nginx/conf.d/localai.conf
   ```

2. **Uncomment các dòng HTTPS**:
   - Uncomment server block HTTPS (dòng 68-139)
   - Uncomment redirect HTTP to HTTPS (dòng 9-12)

3. **Khởi động lại Nginx**:
   ```bash
   docker-compose -f docker-compose.domain.yaml restart nginx
   ```

4. **Truy cập qua HTTPS**:
   ```
   https://localai.makeai.vn
   ```

---

## 🔧 Các Lệnh Quản Lý

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
# Tất cả services
docker-compose -f docker-compose.domain.yaml restart

# Chỉ LocalAI
docker-compose -f docker-compose.domain.yaml restart localai

# Chỉ Nginx
docker-compose -f docker-compose.domain.yaml restart nginx
```

### Dừng services
```bash
docker-compose -f docker-compose.domain.yaml down
```

### Kiểm tra trạng thái
```bash
docker-compose -f docker-compose.domain.yaml ps
```

---

## 🐛 Xử Lý Sự Cố

### Domain không truy cập được

1. **Kiểm tra DNS đã resolve chưa**:
   ```bash
   nslookup localai.makeai.vn
   ping localai.makeai.vn
   ```

2. **Kiểm tra containers đang chạy**:
   ```bash
   docker ps | grep localai
   ```

3. **Kiểm tra logs**:
   ```bash
   docker-compose -f docker-compose.domain.yaml logs
   ```

4. **Kiểm tra port 80/443 đã mở chưa**:
   ```bash
   sudo netstat -tlnp | grep -E ':80|:443'
   ```

### Lỗi 502 Bad Gateway

- LocalAI chưa khởi động xong, chờ thêm vài phút
- Kiểm tra: `docker-compose -f docker-compose.domain.yaml logs localai`

### Không load được model

- Đặt model vào thư mục `models/`
- Khởi động lại: `docker-compose -f docker-compose.domain.yaml restart localai`

---

## 📊 Kiểm Tra Hoạt Động

### Test Health Check
```bash
curl http://localai.makeai.vn/readyz
# Kết quả: OK
```

### Test API
```bash
curl http://localai.makeai.vn/v1/models
# Kết quả: Danh sách models
```

### Test WebUI
Mở trình duyệt: http://localai.makeai.vn

---

## 🔐 Bảo Mật

### Thêm API Key (Tùy chọn)

1. **Sửa file `.env`**:
   ```bash
   API_KEY=your-secret-key-here
   ```

2. **Khởi động lại**:
   ```bash
   docker-compose -f docker-compose.domain.yaml restart localai
   ```

3. **Sử dụng API với key**:
   ```bash
   curl http://localai.makeai.vn/v1/models \
     -H "Authorization: Bearer your-secret-key-here"
   ```

### Giới hạn IP (Tùy chọn)

Thêm vào `nginx/conf.d/localai.conf`:
```nginx
# Chỉ cho phép IP cụ thể
allow 123.123.123.123;
deny all;
```

---

## ✅ Checklist Triển Khai

- [ ] Cấu hình DNS A Record
- [ ] Kiểm tra DNS đã resolve
- [ ] Chạy `./start-domain.sh`
- [ ] Kiểm tra services đang chạy
- [ ] Test domain qua browser
- [ ] Test API endpoint
- [ ] (Tùy chọn) Cấu hình SSL
- [ ] (Tùy chọn) Thêm API key
- [ ] Tải models vào thư mục `models/`

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:
1. Kiểm tra logs: `docker-compose -f docker-compose.domain.yaml logs`
2. Chạy health check: `curl http://localai.makeai.vn/readyz`
3. Xem documentation: README.vi.md

---

**Domain của bạn đã sẵn sàng! 🎉**
