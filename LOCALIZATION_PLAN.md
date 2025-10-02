# 🌍 LocalAI Việt Hóa & Mở Rộng

## 📋 Kế hoạch Việt hóa và phát triển

### ✅ Đã hoàn thành:
1. Clone source code từ GitHub: `localai-source/`
2. Xác định cấu trúc:
   - Templates: `core/http/views/*.html`
   - Static assets: `core/http/static/`
   - JavaScript: `core/http/static/*.js`
3. Tạo WebUI demo tiếng Việt tại `/demo`

---

## 🎯 Roadmap Việt hóa

### Phase 1: Multi-language Support (Đa ngôn ngữ)
- [ ] Tạo hệ thống i18n (internationalization)
- [ ] File ngôn ngữ JSON cho tiếng Việt
- [ ] Chuyển đổi ngôn ngữ động (Language switcher)
- [ ] LocalStorage để lưu preference

### Phase 2: Việt hóa UI Components
- [ ] Navbar (Menu điều hướng)
- [ ] Chat Interface
- [ ] Models Management
- [ ] Settings Panel
- [ ] Error Messages
- [ ] Help Text

### Phase 3: Phát triển thêm tính năng
- [ ] Voice input (Nhập bằng giọng nói)
- [ ] Vietnamese TTS (Text-to-Speech tiếng Việt)
- [ ] Export chat to PDF/Word
- [ ] Chat templates (Mẫu câu hỏi)
- [ ] Dark/Light theme toggle
- [ ] Mobile responsive improvements

---

## 📂 Cấu trúc Source Code

```
localai-source/
├── core/http/
│   ├── views/              # HTML Templates (Go templates)
│   │   ├── index.html      # Trang chủ
│   │   ├── chat.html       # Chat interface
│   │   ├── models.html     # Quản lý models
│   │   ├── backends.html   # Quản lý backends
│   │   ├── p2p.html        # P2P networking
│   │   ├── tts.html        # Text-to-speech
│   │   ├── text2image.html # Image generation
│   │   └── partials/       # Các component dùng chung
│   │       ├── head.html   # <head> tag
│   │       ├── navbar.html # Navigation bar
│   │       └── footer.html # Footer
│   │
│   └── static/             # Static assets
│       ├── chat.js         # Chat logic
│       ├── tts.js          # TTS logic
│       ├── image.js        # Image generation
│       ├── general.css     # Global styles
│       └── assets/         # Images, fonts, etc.
│
├── backend/                # Backend implementations
├── cmd/                    # CLI commands
└── docs/                   # Documentation
```

---

## 🛠️ Cách tiếp cận Việt hóa

### Option 1: Fork & Modify (Khuyên dùng cho production)
1. Fork LocalAI repo
2. Tạo branch `vietnamese-localization`
3. Thêm i18n system
4. Modify templates
5. Build custom Docker image

### Option 2: Overlay/Proxy (Đang dùng - Nhanh cho demo)
1. ✅ Giữ LocalAI gốc unchanged
2. ✅ Tạo custom UI riêng tại `/demo`
3. ✅ Proxy API calls từ custom UI → LocalAI backend
4. Dễ update LocalAI version

### Option 3: Plugin/Extension
1. Tạo middleware để inject translations
2. Override templates dynamically
3. Không modify source code gốc

---

## 📝 File cần Việt hóa

### High Priority (Ưu tiên cao):
```
core/http/views/
├── index.html          # Trang chủ - Cần: tiêu đề, description, buttons
├── chat.html           # Chat UI - Cần: placeholders, labels, messages
├── models.html         # Models - Cần: table headers, actions
└── partials/
    ├── navbar.html     # Menu - Cần: tất cả menu items
    └── head.html       # Meta tags - Cần: title, description
```

### Medium Priority:
```
├── backends.html       # Backend management
├── tts.html           # Text-to-speech
├── text2image.html    # Image generation
└── talk.html          # Voice chat
```

### JavaScript Files:
```
core/http/static/
├── chat.js            # Chat messages, errors
├── tts.js             # TTS UI strings
└── image.js           # Image generation UI
```

---

## 🌐 Tạo hệ thống i18n

### Cấu trúc file ngôn ngữ:

**locales/vi.json:**
```json
{
  "nav": {
    "home": "Trang chủ",
    "chat": "Trò chuyện",
    "models": "Models",
    "settings": "Cài đặt"
  },
  "chat": {
    "placeholder": "Nhập tin nhắn...",
    "send": "Gửi",
    "clear": "Xóa",
    "export": "Xuất",
    "typing": "Đang nhập...",
    "error": "Có lỗi xảy ra"
  },
  "models": {
    "title": "Quản lý Models",
    "install": "Cài đặt",
    "delete": "Xóa",
    "download": "Tải xuống"
  }
}
```

**locales/en.json:**
```json
{
  "nav": {
    "home": "Home",
    "chat": "Chat",
    "models": "Models",
    "settings": "Settings"
  },
  ...
}
```

---

## 🚀 Các bước thực hiện

### Step 1: Tạo custom frontend (✅ DONE)
- [x] Tạo `/webui/index.html` với UI tiếng Việt
- [x] Mount vào Nginx tại `/demo`
- [x] Test hoạt động

### Step 2: Tạo i18n framework
```bash
# Tạo thư mục locales
mkdir -p /home/localai-custom/locales

# Tạo file ngôn ngữ
touch locales/vi.json
touch locales/en.json

# Tạo i18n.js helper
touch static/i18n.js
```

### Step 3: Modify source templates
```bash
# Copy templates gốc
cp -r localai-source/core/http/views /home/localai-custom/views-i18n

# Thêm translation placeholders
# Thay: <h1>Chat</h1>
# Bằng: <h1 data-i18n="chat.title">Chat</h1>
```

### Step 4: Build custom image (Optional)
```dockerfile
FROM localai/localai:latest

# Copy custom views
COPY ./views-i18n /app/views
COPY ./locales /app/locales
COPY ./static-custom /app/static

# Override templates
ENV LOCALAI_TEMPLATES_PATH=/app/views
```

---

## 💡 Quick Implementation

### Approach hiện tại (Recommended):
1. ✅ Giữ LocalAI gốc tại `/` (không động)
2. ✅ Custom UI tiếng Việt tại `/demo`
3. ⏳ Tạo thêm `/vi` với full Việt hóa
4. ⏳ Language switcher để chuyển đổi

### Tạo `/vi` endpoint:
```nginx
# Vietnamese version (full localized)
location /vi {
    alias /usr/share/nginx/html/vi;
    try_files $uri $uri/ /vi/index.html;
}

# Demo chat interface
location /demo {
    alias /usr/share/nginx/html/demo;
    try_files $uri $uri/ /demo/index.html;
}

# Original (English)
location / {
    proxy_pass http://localai_backend;
}
```

---

## 🎨 Tính năng mở rộng đề xuất

### 1. Vietnamese-specific Features:
- **Diacritics handling** (Xử lý dấu tiếng Việt)
- **Vietnamese voice input** (Nhập giọng nói tiếng Việt)
- **Vietnamese TTS** (Đọc văn bản tiếng Việt)
- **Vietnamese prompts library** (Thư viện prompts tiếng Việt)

### 2. Enhanced Chat:
- **Chat history** (Lịch sử trò chuyện)
- **Favorite prompts** (Lưu câu hỏi yêu thích)
- **Multi-chat tabs** (Nhiều cuộc trò chuyện)
- **Markdown preview** (Hiển thị Markdown)
- **Code highlighting** (Syntax highlight cho code)

### 3. Model Management:
- **Auto-download popular models** (Tự động tải models phổ biến)
- **Model recommendations** (Đề xuất models phù hợp)
- **Resource monitor** (Giám sát tài nguyên)
- **Performance stats** (Thống kê hiệu suất)

### 4. User Experience:
- **Dark/Light theme** (Giao diện tối/sáng)
- **Customizable layout** (Tùy chỉnh giao diện)
- **Keyboard shortcuts** (Phím tắt)
- **Mobile app** (PWA for mobile)

---

## 📊 Current Status

### Đã có:
- ✅ Source code từ GitHub
- ✅ Custom Vietnamese UI tại `/demo`
- ✅ API proxy hoạt động
- ✅ SSL/HTTPS enabled

### Đang làm:
- ⏳ Phân tích structure để Việt hóa
- ⏳ Tạo i18n framework
- ⏳ Clone & modify templates

### Tiếp theo:
1. Tạo bản sao views với i18n
2. Build localization system
3. Tạo language switcher
4. Deploy version `/vi`

---

## 🔧 Tools cần thiết

```bash
# Go (để build nếu cần)
apt install golang-go

# Node.js (cho build tools)
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Build tools
npm install -g rollup webpack

# i18n libraries
npm install i18next i18next-browser-languagedetector
```

---

## 📖 Documentation

**LocalAI Official:**
- GitHub: https://github.com/mudler/LocalAI
- Docs: https://localai.io/docs
- API: https://localai.io/api-reference

**Source đã clone:**
- Location: `/home/localai-source`
- Views: `/home/localai-source/core/http/views`
- Static: `/home/localai-source/core/http/static`

---

## 🎯 Next Actions

Bạn muốn:
1. **Tạo full Vietnamese version** tại `/vi`?
2. **Add i18n vào source code** và build custom image?
3. **Phát triển thêm features** cho custom UI?
4. **Tích hợp voice input** tiếng Việt?

Hãy cho tôi biết hướng đi tiếp theo! 🚀
