#!/bin/bash

##############################################################################
# Setup Self-Signed SSL Certificate với OpenSSL
# Script tự động tạo SSL certificate miễn phí cho LocalAI
##############################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

DOMAIN="localai.makeai.vn"
SSL_DIR="./nginx/ssl"
CERT_DAYS=3650  # 10 năm

echo -e "${BLUE}================================================"
echo "🔒 SETUP SELF-SIGNED SSL CERTIFICATE"
echo -e "================================================${NC}\n"

# Kiểm tra OpenSSL
echo -e "${YELLOW}[1/6]${NC} Kiểm tra OpenSSL..."
if ! command -v openssl &> /dev/null; then
    echo -e "${RED}✗ OpenSSL chưa được cài đặt${NC}"
    echo "Đang cài đặt OpenSSL..."
    sudo apt-get update
    sudo apt-get install -y openssl
fi
echo -e "${GREEN}✓ OpenSSL đã sẵn sàng: $(openssl version)${NC}\n"

# Tạo thư mục SSL
echo -e "${YELLOW}[2/6]${NC} Tạo thư mục SSL..."
mkdir -p "$SSL_DIR"
echo -e "${GREEN}✓ Thư mục: $SSL_DIR${NC}\n"

# Tạo private key
echo -e "${YELLOW}[3/6]${NC} Tạo private key (RSA 4096-bit)..."
openssl genrsa -out "$SSL_DIR/privkey.pem" 4096 2>/dev/null
chmod 600 "$SSL_DIR/privkey.pem"
echo -e "${GREEN}✓ Private key: $SSL_DIR/privkey.pem${NC}\n"

# Tạo certificate signing request (CSR)
echo -e "${YELLOW}[4/6]${NC} Tạo Certificate Signing Request..."
openssl req -new \
    -key "$SSL_DIR/privkey.pem" \
    -out "$SSL_DIR/cert.csr" \
    -subj "/C=VN/ST=HoChiMinh/L=HoChiMinh/O=MakeAI/OU=IT/CN=$DOMAIN" \
    2>/dev/null
echo -e "${GREEN}✓ CSR: $SSL_DIR/cert.csr${NC}\n"

# Tạo self-signed certificate
echo -e "${YELLOW}[5/6]${NC} Tạo self-signed certificate (valid ${CERT_DAYS} ngày)..."
openssl x509 -req \
    -days $CERT_DAYS \
    -in "$SSL_DIR/cert.csr" \
    -signkey "$SSL_DIR/privkey.pem" \
    -out "$SSL_DIR/fullchain.pem" \
    -extfile <(printf "subjectAltName=DNS:$DOMAIN,DNS:*.$DOMAIN,DNS:localhost,IP:127.0.0.1") \
    2>/dev/null
chmod 644 "$SSL_DIR/fullchain.pem"
echo -e "${GREEN}✓ Certificate: $SSL_DIR/fullchain.pem${NC}\n"

# Hiển thị thông tin certificate
echo -e "${BLUE}📋 Thông tin Certificate:${NC}"
openssl x509 -in "$SSL_DIR/fullchain.pem" -noout -text | grep -E "(Subject:|Issuer:|Not Before|Not After|DNS:)"
echo ""

# Cập nhật Nginx configuration
echo -e "${YELLOW}[6/6]${NC} Cập nhật Nginx configuration..."

# Backup file gốc
if [ -f "./nginx/conf.d/localai.conf" ]; then
    cp ./nginx/conf.d/localai.conf ./nginx/conf.d/localai.conf.backup
    echo -e "${GREEN}✓ Backup: localai.conf.backup${NC}"
fi

# Tạo config mới với SSL
cat > ./nginx/conf.d/localai.conf << 'EOF'
upstream localai_backend {
    server localai:8080;
}

# HTTP -> HTTPS redirect
server {
    listen 80;
    listen [::]:80;
    server_name localai.makeai.vn;

    # Health check endpoint (không redirect)
    location /readyz {
        proxy_pass http://localai_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Redirect tất cả requests khác sang HTTPS
    location / {
        return 301 https://$server_name$request_uri;
    }
}

# HTTPS Server
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name localai.makeai.vn;

    # SSL Configuration
    ssl_certificate /etc/nginx/ssl/fullchain.pem;
    ssl_certificate_key /etc/nginx/ssl/privkey.pem;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # Security Headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Client settings
    client_max_body_size 100M;
    client_body_timeout 120s;
    proxy_read_timeout 300s;
    proxy_connect_timeout 75s;

    # Root
    location / {
        proxy_pass http://localai_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # API endpoints
    location /v1/ {
        proxy_pass http://localai_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health check
    location /readyz {
        proxy_pass http://localai_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        access_log off;
    }

    # Swagger UI
    location /swagger/ {
        proxy_pass http://localai_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # Static files
    location /static/ {
        proxy_pass http://localai_backend;
        proxy_set_header Host $host;
        expires 7d;
        add_header Cache-Control "public, immutable";
    }
}
EOF

echo -e "${GREEN}✓ Nginx config đã cập nhật${NC}\n"

# Khởi động lại Nginx
echo -e "${YELLOW}Khởi động lại Nginx...${NC}"
if docker compose -f docker-compose.domain.yaml restart nginx; then
    echo -e "${GREEN}✓ Nginx đã khởi động lại${NC}\n"
else
    echo -e "${RED}✗ Lỗi khi khởi động lại Nginx${NC}\n"
    exit 1
fi

# Kiểm tra SSL
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}✅ HOÀN THÀNH! SSL ĐÃ ĐƯỢC CÀI ĐẶT${NC}"
echo -e "${BLUE}================================================${NC}\n"

echo -e "${GREEN}📋 Thông tin:${NC}"
echo "   Certificate: $SSL_DIR/fullchain.pem"
echo "   Private Key: $SSL_DIR/privkey.pem"
echo "   Valid for:   $CERT_DAYS ngày (10 năm)"
echo "   Domain:      $DOMAIN"
echo ""

echo -e "${YELLOW}⚠️  QUAN TRỌNG - Self-Signed Certificate:${NC}"
echo "   - Certificate này là self-signed (tự ký)"
echo "   - Trình duyệt sẽ cảnh báo 'Not Secure' lần đầu"
echo "   - Bạn cần chấp nhận/tin tưởng certificate thủ công"
echo ""

echo -e "${BLUE}🌐 Truy cập hệ thống:${NC}"
echo "   HTTP:  http://localai.makeai.vn"
echo "   HTTPS: https://localai.makeai.vn"
echo ""

echo -e "${YELLOW}📝 Cách tin tưởng certificate:${NC}"
echo ""
echo "   ${GREEN}Chrome/Edge:${NC}"
echo "   1. Truy cập https://localai.makeai.vn"
echo "   2. Click 'Advanced' → 'Proceed to localai.makeai.vn (unsafe)'"
echo "   3. Hoặc gõ 'thisisunsafe' khi thấy cảnh báo"
echo ""
echo "   ${GREEN}Firefox:${NC}"
echo "   1. Truy cập https://localai.makeai.vn"
echo "   2. Click 'Advanced' → 'Accept the Risk and Continue'"
echo ""
echo "   ${GREEN}curl:${NC}"
echo "   curl -k https://localai.makeai.vn/readyz"
echo "   (flag -k bỏ qua SSL verification)"
echo ""

echo -e "${BLUE}🔍 Test SSL:${NC}"
echo "   # Test local"
echo "   curl -k https://localhost/readyz"
echo ""
echo "   # Test domain"
echo "   curl -k https://localai.makeai.vn/readyz"
echo ""
echo "   # Kiểm tra certificate"
echo "   openssl s_client -connect localai.makeai.vn:443 -servername localai.makeai.vn"
echo ""

echo -e "${GREEN}✅ Self-signed SSL certificate đã sẵn sàng!${NC}"
echo -e "${YELLOW}💡 Nếu muốn certificate tin cậy (không cảnh báo), dùng Let's Encrypt:${NC}"
echo -e "   ./setup-ssl.sh"
echo ""
