# 🔒 Hướng Dẫn Trust SSL Certificate

## ✅ Trạng thái
- **Server Linux:** ✅ Đã tin cậy (system-wide)
- **curl/wget:** ✅ Không cảnh báo
- **Các thiết bị khác:** Cần import certificate

---

## 📥 Tải Certificate

### Từ Server (nếu bạn có SSH)
```bash
# Tải về máy local
scp root@103.65.235.141:/home/nginx/ssl/fullchain.pem localai-cert.pem
```

### Qua HTTP
```bash
# Tạm thời serve file certificate
cd /home/nginx/ssl
python3 -m http.server 8888

# Trên máy khác, tải về:
wget http://103.65.235.141:8888/fullchain.pem -O localai-cert.pem
```

---

## 💻 Windows

### Chrome / Edge / Brave
1. Tải file `fullchain.pem`
2. Đổi tên thành `localai-cert.crt` (không bắt buộc)
3. **Double-click** file
4. Click **Install Certificate**
5. Chọn **Local Machine** → Next
6. Chọn **Place all certificates in the following store**
7. Click **Browse** → Chọn **Trusted Root Certification Authorities**
8. Click **Next** → **Finish**
9. **Khởi động lại trình duyệt**

### Firefox (riêng biệt)
1. Mở Firefox
2. Settings → Privacy & Security
3. Certificates → **View Certificates**
4. Tab **Authorities** → **Import**
5. Chọn file `fullchain.pem`
6. Check **Trust this CA to identify websites**
7. OK → **Khởi động lại Firefox**

---

## 🍎 macOS

### Safari / Chrome
1. Tải file `fullchain.pem`
2. Mở **Keychain Access** (Spotlight → gõ "Keychain")
3. Kéo file vào **System** keychain (hoặc Login)
4. Double-click certificate vừa thêm
5. Expand **Trust** section
6. Chọn **Always Trust** cho "When using this certificate"
7. Đóng window (nhập password admin)
8. **Khởi động lại trình duyệt**

### Terminal (curl/wget)
```bash
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain localai-cert.pem
```

---

## 🐧 Linux Desktop

### Ubuntu / Debian
```bash
# Copy certificate
sudo cp localai-cert.pem /usr/local/share/ca-certificates/localai.crt

# Update
sudo update-ca-certificates

# Khởi động lại trình duyệt
```

### Fedora / CentOS / RHEL
```bash
# Copy certificate
sudo cp localai-cert.pem /etc/pki/ca-trust/source/anchors/localai.crt

# Update
sudo update-ca-trust

# Khởi động lại trình duyệt
```

### Arch Linux
```bash
# Copy certificate
sudo cp localai-cert.pem /etc/ca-certificates/trust-source/anchors/localai.crt

# Update
sudo trust extract-compat

# Khởi động lại trình duyệt
```

---

## 📱 Android

### Method 1: Via Settings
1. Copy file `fullchain.pem` vào điện thoại
2. Settings → Security → **Encryption & credentials**
3. **Install a certificate** → **CA certificate**
4. Chọn file (có thể cần đổi tên thành `.crt`)
5. Nhập PIN/Password
6. Đặt tên: "LocalAI"

### Method 2: Via Browser
1. Truy cập `https://localai.makeai.vn`
2. Click cảnh báo → **Advanced**
3. **Install Certificate** (nếu có option)

**⚠️ Lưu ý:** 
- Android 11+ yêu cầu app phải khai báo trust user certificates
- Một số app không tin cậy user-installed certificates

---

## 📱 iOS / iPadOS

### Qua AirDrop / Email
1. Gửi file `fullchain.pem` qua AirDrop hoặc email
2. Mở file → **Install Profile**
3. Settings → **General** → **VPN & Device Management**
4. Chọn profile vừa cài → **Install**
5. Nhập passcode
6. **Settings** → **General** → **About**
7. **Certificate Trust Settings** (cuối trang)
8. Bật switch cho "LocalAI certificate"

### Qua Safari
1. Truy cập URL có certificate (https://localai.makeai.vn)
2. Safari sẽ tự động phát hiện và hỏi cài đặt

---

## 🦊 Firefox (Tất cả platforms)

Firefox dùng certificate store riêng, không dùng system store.

### Desktop
1. Mở Firefox
2. `about:preferences#privacy`
3. Scroll xuống **Certificates** → **View Certificates**
4. Tab **Authorities** → **Import**
5. Chọn `fullchain.pem`
6. Check ☑ **Trust this CA to identify websites**
7. OK

### Mobile
Firefox Mobile hiện không hỗ trợ import CA certificate.
Chỉ có thể accept exception từng lần.

---

## 🐳 Docker Containers

Nếu container khác cần gọi API:

```dockerfile
# Trong Dockerfile
COPY fullchain.pem /usr/local/share/ca-certificates/localai.crt
RUN update-ca-certificates
```

Hoặc mount volume:
```yaml
volumes:
  - ./nginx/ssl/fullchain.pem:/usr/local/share/ca-certificates/localai.crt:ro
```

---

## 🧪 Kiểm Tra

### Từ terminal
```bash
# Không cảnh báo (trusted)
curl https://localai.makeai.vn/readyz

# Với cảnh báo (không trusted)
curl -k https://localai.makeai.vn/readyz
```

### Từ browser
1. Mở `https://localai.makeai.vn`
2. Click biểu tượng **🔒** trên address bar
3. Xem certificate details
4. **Không có cảnh báo = Thành công!**

### Kiểm tra certificate info
```bash
openssl s_client -connect localai.makeai.vn:443 \
  -servername localai.makeai.vn < /dev/null 2>/dev/null | \
  openssl x509 -noout -text
```

---

## ❓ Troubleshooting

### Vẫn thấy cảnh báo sau khi import?

**1. Khởi động lại trình duyệt**
   - Đóng hoàn toàn (kill process)
   - Mở lại

**2. Clear browser cache**
   - Chrome: Ctrl+Shift+Del → Clear cache
   - Firefox: Ctrl+Shift+Del → Clear cache

**3. Kiểm tra certificate đã import đúng chưa**
   ```bash
   # Linux
   ls -la /usr/local/share/ca-certificates/
   
   # macOS
   security find-certificate -a -c "localai.makeai.vn"
   ```

**4. Đảm bảo domain trỏ đúng IP**
   ```bash
   nslookup localai.makeai.vn
   # Phải trả về: 103.65.235.141
   ```

**5. Thử incognito/private mode**
   - Nếu incognito OK → Clear browser data
   - Nếu incognito vẫn lỗi → Certificate chưa được trust

### Certificate hết hạn?

Certificate này valid **10 năm** (đến 2035).

Nếu cần tạo mới:
```bash
./setup-ssl-selfsigned.sh  # Tạo lại certificate
./trust-ssl-cert.sh        # Trust lại
```

---

## 🔄 Alternative: Let's Encrypt

Nếu muốn certificate **TIN CẬY SẴN** (không cần import):

```bash
./setup-ssl.sh
```

**Yêu cầu:**
- DNS đã trỏ đúng (localai.makeai.vn → 103.65.235.141)
- Port 80/443 mở public
- Domain verify được qua HTTP

**Ưu điểm:**
- ✅ Tin cậy mặc định trên mọi thiết bị
- ✅ Không cảnh báo
- ✅ Tự động renew

**Nhược điểm:**
- ❌ Cần domain public
- ❌ Renew mỗi 90 ngày

---

## 📋 Summary

| Platform | Method | Difficulty |
|----------|--------|-----------|
| Linux Server | ✅ Auto (đã xong) | Easy |
| Windows | Import to Cert Store | Medium |
| macOS | Keychain Access | Medium |
| Android | Settings → Security | Medium |
| iOS | Profile + Trust Settings | Hard |
| Firefox | Import to Firefox | Easy |
| Docker | Mount cert + update-ca | Easy |

---

## 🎯 Quick Commands

```bash
# Tạo certificate mới
./setup-ssl-selfsigned.sh

# Trust trên server
./trust-ssl-cert.sh

# Tải certificate về máy khác
scp root@103.65.235.141:/home/nginx/ssl/fullchain.pem .

# Test HTTPS
curl https://localai.makeai.vn/readyz

# Xem certificate info
openssl x509 -in fullchain.pem -noout -text
```

---

**✅ Certificate đã trusted trên server Linux!**  
**📥 Tải về và import cho các thiết bị khác.**
