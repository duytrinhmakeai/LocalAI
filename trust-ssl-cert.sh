#!/bin/bash

##############################################################################
# Trust Self-Signed SSL Certificate
# Script thêm certificate vào danh sách tin cậy của hệ thống
##############################################################################

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

CERT_FILE="./nginx/ssl/fullchain.pem"
DOMAIN="localai.makeai.vn"

echo -e "${BLUE}================================================"
echo "🔒 TRUST SELF-SIGNED SSL CERTIFICATE"
echo -e "================================================${NC}\n"

# Kiểm tra certificate tồn tại
if [ ! -f "$CERT_FILE" ]; then
    echo -e "${RED}✗ Certificate không tồn tại: $CERT_FILE${NC}"
    echo "Chạy ./setup-ssl-selfsigned.sh trước"
    exit 1
fi

echo -e "${YELLOW}[1/4]${NC} Kiểm tra certificate..."
echo -e "${GREEN}✓ Certificate: $CERT_FILE${NC}\n"

# Cài đặt ca-certificates nếu chưa có
echo -e "${YELLOW}[2/4]${NC} Kiểm tra ca-certificates..."
if ! dpkg -l | grep -q ca-certificates; then
    echo "Đang cài đặt ca-certificates..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates
fi
echo -e "${GREEN}✓ ca-certificates đã sẵn sàng${NC}\n"

# Copy certificate vào thư mục trusted
echo -e "${YELLOW}[3/4]${NC} Thêm certificate vào hệ thống..."
sudo cp "$CERT_FILE" "/usr/local/share/ca-certificates/${DOMAIN}.crt"
sudo update-ca-certificates
echo -e "${GREEN}✓ Certificate đã được thêm vào danh sách tin cậy${NC}\n"

# Kiểm tra
echo -e "${YELLOW}[4/4]${NC} Kiểm tra kết nối HTTPS..."
if curl -s https://localhost/readyz > /dev/null 2>&1; then
    echo -e "${GREEN}✓ HTTPS hoạt động không có cảnh báo!${NC}\n"
else
    echo -e "${YELLOW}⚠ Có thể cần khởi động lại terminal/shell${NC}\n"
fi

echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}✅ HOÀN THÀNH!${NC}"
echo -e "${BLUE}================================================${NC}\n"

echo -e "${GREEN}📋 Certificate đã được tin cậy:${NC}"
echo "   Location: /usr/local/share/ca-certificates/${DOMAIN}.crt"
echo "   Domain:   $DOMAIN"
echo ""

echo -e "${BLUE}🔍 Test không cảnh báo:${NC}"
echo "   # Không cần flag -k nữa"
echo "   curl https://localhost/readyz"
echo "   curl https://localai.makeai.vn/readyz"
echo ""

echo -e "${YELLOW}📝 Để trình duyệt tin cậy certificate:${NC}"
echo ""
echo -e "${GREEN}   Linux (Chrome/Edge/Firefox):${NC}"
echo "   Certificate đã được thêm vào hệ thống"
echo "   Khởi động lại trình duyệt để áp dụng"
echo ""
echo -e "${GREEN}   Windows:${NC}"
echo "   1. Tải certificate: scp user@$DOMAIN:$CERT_FILE ."
echo "   2. Double-click file .pem"
echo "   3. Install Certificate → Local Machine"
echo "   4. Place in 'Trusted Root Certification Authorities'"
echo ""
echo -e "${GREEN}   macOS:${NC}"
echo "   1. Tải certificate xuống"
echo "   2. Mở Keychain Access"
echo "   3. Kéo file .pem vào 'System' keychain"
echo "   4. Double-click → Trust → Always Trust"
echo ""
echo -e "${GREEN}   Android:${NC}"
echo "   Settings → Security → Install from storage"
echo "   Chọn file certificate"
echo ""
echo -e "${GREEN}   iOS:${NC}"
echo "   1. Gửi file .pem qua email/AirDrop"
echo "   2. Settings → General → Profiles"
echo "   3. Install profile"
echo "   4. Settings → General → About → Certificate Trust Settings"
echo "   5. Bật tin cậy cho certificate"
echo ""

echo -e "${BLUE}✨ Tips:${NC}"
echo "   - Server Linux: Certificate đã được tin cậy system-wide"
echo "   - Máy khác: Cần import certificate thủ công"
echo "   - Trình duyệt: Có thể cần khởi động lại"
echo ""

echo -e "${GREEN}✅ SSL certificate đã tin cậy trên server này!${NC}"
