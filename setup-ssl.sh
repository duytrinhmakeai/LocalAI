#!/bin/bash

# Script cài đặt SSL certificate cho localai.makeai.vn

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

DOMAIN="localai.makeai.vn"
EMAIL=""

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   SSL Certificate Setup${NC}"
echo -e "${BLUE}   Domain: $DOMAIN${NC}"
echo -e "${BLUE}========================================${NC}"
echo

# Nhập email
read -p "Nhập email của bạn: " EMAIL

if [ -z "$EMAIL" ]; then
    echo -e "${RED}Email không được để trống!${NC}"
    exit 1
fi

echo
echo -e "${YELLOW}Đang cài đặt Certbot...${NC}"

# Cài đặt Certbot
if ! command -v certbot &> /dev/null; then
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
fi

echo -e "${GREEN}✓ Certbot đã sẵn sàng${NC}"
echo

# Dừng nginx tạm thời để certbot bind port 80
echo -e "${YELLOW}Dừng Nginx tạm thời...${NC}"
docker-compose -f docker-compose.domain.yaml stop nginx

echo
echo -e "${YELLOW}Tạo SSL certificate...${NC}"
echo -e "${BLUE}Domain: $DOMAIN${NC}"
echo -e "${BLUE}Email: $EMAIL${NC}"
echo

# Tạo certificate
sudo certbot certonly --standalone \
    -d $DOMAIN \
    --email $EMAIL \
    --agree-tos \
    --non-interactive

if [ $? -eq 0 ]; then
    echo
    echo -e "${GREEN}✓ Certificate đã được tạo thành công!${NC}"
    echo
    
    # Copy certificates
    echo -e "${YELLOW}Copy certificates vào nginx/ssl/...${NC}"
    sudo mkdir -p nginx/ssl
    sudo cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem nginx/ssl/$DOMAIN.crt
    sudo cp /etc/letsencrypt/live/$DOMAIN/privkey.pem nginx/ssl/$DOMAIN.key
    sudo chown -R $(whoami):$(whoami) nginx/ssl/
    
    echo -e "${GREEN}✓ Certificates đã được copy${NC}"
    echo
    
    # Update Nginx config
    echo -e "${YELLOW}Cập nhật cấu hình Nginx...${NC}"
    
    # Backup original config
    cp nginx/conf.d/localai.conf nginx/conf.d/localai.conf.bak
    
    # Enable HTTPS in config (uncomment HTTPS server block)
    sed -i 's/^# server {$/server {/g' nginx/conf.d/localai.conf
    sed -i 's/^#     /    /g' nginx/conf.d/localai.conf
    sed -i 's/^# }/}/g' nginx/conf.d/localai.conf
    
    echo -e "${GREEN}✓ Cấu hình Nginx đã được cập nhật${NC}"
    echo
    
    # Khởi động lại nginx
    echo -e "${YELLOW}Khởi động lại Nginx...${NC}"
    docker-compose -f docker-compose.domain.yaml start nginx
    docker-compose -f docker-compose.domain.yaml restart nginx
    
    echo
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}   ✓ SSL ĐÃ ĐƯỢC CÀI ĐẶT!${NC}"
    echo -e "${GREEN}========================================${NC}"
    echo
    echo -e "${YELLOW}🌐 Truy cập qua HTTPS:${NC}"
    echo -e "   ${GREEN}https://$DOMAIN${NC}"
    echo
    echo -e "${YELLOW}📋 Certificate info:${NC}"
    echo -e "   Location: /etc/letsencrypt/live/$DOMAIN/"
    echo -e "   Expires: $(sudo certbot certificates | grep Expiry | head -1)"
    echo
    echo -e "${YELLOW}🔄 Gia hạn tự động:${NC}"
    echo -e "   Certbot sẽ tự động gia hạn certificate"
    echo -e "   Hoặc chạy thủ công: sudo certbot renew"
    echo
    
else
    echo -e "${RED}✗ Không thể tạo certificate!${NC}"
    echo -e "${YELLOW}Khởi động lại Nginx...${NC}"
    docker-compose -f docker-compose.domain.yaml start nginx
    exit 1
fi
