#!/bin/bash

# LocalAI Domain Startup Script
# Khởi động LocalAI với domain localai.makeai.vn

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}   LocalAI với Domain: localai.makeai.vn${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo
}

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_header

# Kiểm tra Docker
echo -e "${BLUE}Bước 1: Kiểm tra Docker...${NC}"
if ! command -v docker &> /dev/null; then
    print_error "Docker chưa được cài đặt!"
    echo "Vui lòng cài đặt Docker trước:"
    echo "  curl -fsSL https://get.docker.com | sh"
    exit 1
fi
print_status "Docker đã sẵn sàng"

# Kiểm tra Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose chưa được cài đặt!"
    exit 1
fi
print_status "Docker Compose đã sẵn sàng"
echo

# Tạo thư mục cần thiết
echo -e "${BLUE}Bước 2: Tạo thư mục...${NC}"
mkdir -p models backends gallery configuration nginx/logs nginx/ssl
print_status "Thư mục đã được tạo"
echo

# Dừng các container cũ (nếu có)
echo -e "${BLUE}Bước 3: Dọn dẹp containers cũ...${NC}"
docker compose -f docker-compose.domain.yaml down 2>/dev/null || true
print_status "Đã dừng containers cũ"
echo

# Khởi động services
echo -e "${BLUE}Bước 4: Khởi động LocalAI...${NC}"
docker compose -f docker-compose.domain.yaml up -d

if [ $? -eq 0 ]; then
    print_status "LocalAI đã được khởi động thành công!"
    echo
    
    echo -e "${YELLOW}⏳ Đang chờ services khởi động hoàn tất...${NC}"
    sleep 10
    
    # Kiểm tra trạng thái
    echo
    echo -e "${BLUE}Bước 5: Kiểm tra services...${NC}"
    docker compose -f docker-compose.domain.yaml ps
    
    echo
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}      ✓ KHỞI ĐỘNG THÀNH CÔNG!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo
    echo -e "${YELLOW}📌 QUAN TRỌNG: Cấu hình DNS${NC}"
    echo -e "   Bạn cần trỏ domain ${BLUE}localai.makeai.vn${NC} về IP của server này"
    echo
    echo -e "${YELLOW}🌐 Truy cập LocalAI:${NC}"
    echo -e "   - Domain: ${GREEN}http://localai.makeai.vn${NC}"
    echo -e "   - Localhost: ${GREEN}http://localhost${NC}"
    echo -e "   - API: ${GREEN}http://localai.makeai.vn/v1${NC}"
    echo -e "   - Health: ${GREEN}http://localai.makeai.vn/readyz${NC}"
    echo -e "   - Swagger: ${GREEN}http://localai.makeai.vn/swagger${NC}"
    echo
    echo -e "${YELLOW}📊 Kiểm tra logs:${NC}"
    echo -e "   docker compose -f docker-compose.domain.yaml logs -f"
    echo
    echo -e "${YELLOW}🔧 Dừng services:${NC}"
    echo -e "   docker compose -f docker-compose.domain.yaml down"
    echo
    echo -e "${YELLOW}🔒 Để bật HTTPS:${NC}"
    echo -e "   1. Lấy SSL certificate (Let's Encrypt hoặc CloudFlare)"
    echo -e "   2. Đặt certificate vào nginx/ssl/"
    echo -e "   3. Uncomment phần HTTPS trong nginx/conf.d/localai.conf"
    echo -e "   4. Khởi động lại: docker compose -f docker-compose.domain.yaml restart nginx"
    echo
    echo -e "${GREEN}========================================${NC}"
    
else
    print_error "Không thể khởi động LocalAI!"
    echo "Kiểm tra logs: docker compose -f docker-compose.domain.yaml logs"
    exit 1
fi
