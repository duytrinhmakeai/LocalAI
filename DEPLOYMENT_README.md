# LocalAI MakeAI - Deployment Package

Thư mục này chứa tất cả các file cần thiết để triển khai LocalAI phiên bản Việt hóa.

## 📂 Cấu trúc

```
deployment/
├── scripts/              # Deployment scripts
├── config/              # Configuration files
├── docs/                # Vietnamese documentation
└── docker/              # Docker configs
```

## 🚀 Quick Deploy

```bash
# Clone repository
git clone https://github.com/duytrinhmakeai/LocalAI.git
cd LocalAI

# Run deployment
./start-domain.sh

# Access
https://localai.makeai.vn/vi
```

## 📝 Files Overview

### Scripts
- `install.sh` - Installation script
- `start.sh` - Basic start
- `start-domain.sh` - Start with domain
- `setup-ssl.sh` - Let's Encrypt SSL
- `setup-ssl-selfsigned.sh` - Self-signed SSL
- `trust-ssl-cert.sh` - Trust certificate
- `download-models.sh` - Download AI models
- `monitor.sh` - System monitoring
- `backup.sh` - Backup/restore

### Configuration
- `docker-compose.domain.yaml` - Docker deployment
- `nginx/` - Nginx configuration
- `configuration/` - LocalAI configs
- `.env` - Environment variables

### Documentation
- `README.VIETNAMESE.md` - Main Vietnamese docs
- `DEPLOYMENT_SUCCESS.md` - Deployment report
- `LOCALIZATION_PLAN.md` - Localization roadmap
- `SSL_SETUP_COMPLETE.md` - SSL guide
- And more...
