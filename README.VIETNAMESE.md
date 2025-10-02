# LocalAI - Vietnamese Localization by MakeAI

🇻🇳 **Phiên bản Việt hóa của LocalAI** - Trợ lý AI miễn phí, mã nguồn mở, chạy hoàn toàn cục bộ.

---

## 🌟 Tính năng

- ✅ **Giao diện hoàn toàn tiếng Việt**
- ✅ **Logo MakeAI tùy chỉnh**
- ✅ **Chat interface thân thiện**
- ✅ **Tương thích 100% với LocalAI gốc**
- ✅ **SSL/HTTPS tích hợp sẵn**
- ✅ **Responsive design (Mobile friendly)**

---

## 🚀 Demo

- **Trang chủ tiếng Việt**: https://localai.makeai.vn/vi
- **Chat Demo**: https://localai.makeai.vn/demo
- **Trang gốc (English)**: https://localai.makeai.vn

---

## 📦 Cài đặt nhanh

```bash
# Clone repository
git clone https://github.com/duytrinhmakeai/LocalAI.git
cd LocalAI

# Copy file cấu hình (từ deployment hiện tại)
cp -r /home/webui ./webui
cp -r /home/nginx ./nginx
cp /home/docker-compose.domain.yaml ./

# Khởi động
docker compose -f docker-compose.domain.yaml up -d
```

---

## 🏗️ Cấu trúc Project

```
LocalAI/
├── webui/                      # Vietnamese UI
│   ├── index.html             # Chat demo (tiếng Việt)
│   ├── makeailogo.jpg         # MakeAI logo
│   └── vi/
│       └── index.html         # Trang chủ đầy đủ (tiếng Việt)
│
├── nginx/                      # Nginx configuration
│   ├── conf.d/
│   │   └── localai.conf       # Reverse proxy + routing
│   └── ssl/                   # SSL certificates
│
├── core/http/                  # LocalAI core (gốc)
│   ├── views/                 # Templates HTML
│   └── static/                # Assets
│
└── docker-compose.domain.yaml  # Docker deployment
```

---

## 🌐 Endpoints

| URL | Mô tả | Ngôn ngữ |
|-----|-------|----------|
| `/` | LocalAI Dashboard gốc | English |
| `/vi` | Trang chủ tiếng Việt | Tiếng Việt |
| `/demo` | Chat interface | Tiếng Việt |
| `/chat` | Chat (gốc) | English |
| `/models` | Quản lý models | English |
| `/browse` | Thư viện models | English |
| `/v1/*` | API endpoints | - |
| `/swagger` | API docs | English |

---

## 🔧 Development

### Prerequisites
- Docker & Docker Compose
- Git
- (Optional) Node.js cho build tools

### Setup Development Environment

```bash
# 1. Clone repo
git clone https://github.com/duytrinhmakeai/LocalAI.git
cd LocalAI

# 2. Checkout Vietnamese branch
git checkout vietnamese-localization

# 3. Copy custom files từ deployment
# (Nếu đang phát triển trên server hiện tại)

# 4. Test local
docker compose -f docker-compose.domain.yaml up
```

### File Structure for Localization

**Custom Vietnamese UI:**
```
webui/
├── index.html          # Chat demo
├── makeailogo.jpg      # Logo
└── vi/
    └── index.html      # Vietnamese homepage
```

**Modified Files:**
```
nginx/conf.d/localai.conf    # Added /vi and /demo routes
docker-compose.domain.yaml    # Added webui volume mount
```

---

## 🎨 Customization

### Thay đổi Logo

```bash
# Thay file logo
cp /path/to/your/logo.jpg webui/makeailogo.jpg

# Restart Nginx
docker compose -f docker-compose.domain.yaml restart nginx
```

### Tùy chỉnh giao diện

Edit files:
- `webui/vi/index.html` - Trang chủ tiếng Việt
- `webui/index.html` - Chat demo

Sau đó restart Nginx để áp dụng thay đổi.

---

## 📝 Roadmap

### Phase 1: ✅ Hoàn thành
- [x] Trang chủ tiếng Việt
- [x] Chat interface tiếng Việt
- [x] Logo MakeAI
- [x] SSL/HTTPS
- [x] Nginx routing

### Phase 2: 🔄 Đang thực hiện
- [ ] Việt hóa tất cả views (chat.html, models.html, etc.)
- [ ] i18n framework (đa ngôn ngữ động)
- [ ] Language switcher component
- [ ] Vietnamese documentation

### Phase 3: 📅 Kế hoạch
- [ ] Vietnamese voice input
- [ ] Vietnamese TTS
- [ ] Vietnamese prompt templates
- [ ] Mobile PWA app
- [ ] Advanced chat features

---

## 🤝 Contributing

Contributions are welcome! 

### How to contribute:

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Areas needing help:
- 🌐 Translation (Việt hóa thêm các trang)
- 🎨 UI/UX improvements
- 📝 Documentation
- 🐛 Bug fixes
- ✨ New features

---

## 📖 Documentation

### Original LocalAI
- [Official Docs](https://localai.io)
- [GitHub](https://github.com/mudler/LocalAI)
- [API Reference](https://localai.io/api-reference)

### Vietnamese Version
- [Hướng dẫn cài đặt](/home/README.vi.md)
- [Kế hoạch Việt hóa](/home/LOCALIZATION_PLAN.md)
- [Báo cáo tiến độ](/home/PROGRESS_REPORT.md)

---

## 🔐 Security

- ✅ SSL/HTTPS enabled
- ✅ Self-signed certificate (hoặc Let's Encrypt)
- ✅ Chạy hoàn toàn cục bộ
- ✅ Không gửi data ra ngoài

### SSL Setup

```bash
# Self-signed (nhanh)
./setup-ssl-selfsigned.sh
./trust-ssl-cert.sh

# Let's Encrypt (cho production)
./setup-ssl.sh
```

---

## 📊 Status

- **Server**: 103.65.235.141
- **Domain**: localai.makeai.vn
- **Status**: ✅ Production
- **Version**: v3.5.4 (LocalAI) + Vietnamese Localization
- **Uptime**: Monitoring via Docker healthcheck

---

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/duytrinhmakeai/LocalAI/issues)
- **Discussions**: [GitHub Discussions](https://github.com/duytrinhmakeai/LocalAI/discussions)
- **Email**: contact@makeai.vn (nếu có)

---

## 📜 License

- **LocalAI**: MIT License (Original project by @mudler)
- **Vietnamese Localization**: MIT License (MakeAI Vietnam)

---

## 🙏 Credits

- **LocalAI**: [mudler/LocalAI](https://github.com/mudler/LocalAI)
- **Vietnamese Localization**: MakeAI Vietnam Team
- **Logo**: MakeAI Vietnam
- **Deployment**: localai.makeai.vn

---

## 🌍 About MakeAI

**MakeAI Vietnam** - Đưa AI đến gần hơn với người Việt

- Website: makeai.vn (nếu có)
- GitHub: [github.com/duytrinhmakeai](https://github.com/duytrinhmakeai)
- Demo: [localai.makeai.vn](https://localai.makeai.vn)

---

## 📸 Screenshots

### Trang chủ tiếng Việt
![Vietnamese Homepage](docs/screenshots/homepage-vi.png)

### Chat Interface
![Chat Demo](docs/screenshots/chat-demo.png)

### Model Management
![Models](docs/screenshots/models.png)

---

## 🚀 Quick Start

```bash
# Cài đặt nhanh nhất
curl -fsSL https://localai.makeai.vn/install.sh | bash

# Hoặc thủ công
git clone https://github.com/duytrinhmakeai/LocalAI.git
cd LocalAI
./start-domain.sh
```

Sau đó truy cập: **https://localai.makeai.vn/vi**

---

**Made with ❤️ in Vietnam 🇻🇳**
