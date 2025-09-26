# TruyenQQ Clone - Production Setup

Quick setup script for deploying TruyenQQ Clone with Docker and Cloudflare Tunnel on Ubuntu.

## Features

- 🐳 Automated Docker & Docker Compose installation
- 🔐 GitHub Container Registry authentication via browser
- 🌐 Cloudflare Tunnel for secure exposure
- ⚡ One-command deployment

## Prerequisites

- Ubuntu server (20.04 or later)
- Cloudflare account with tunnel token
- GitHub account for private registry access

## Quick Start

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/truyenqq-setup.git
cd truyenqq-setup

# Run installation script
sudo bash install.sh

# Configure environment
cp .env.example .env
nano .env  # Add your CLOUDFLARED_TOKEN and database credentials

# Deploy
docker compose up -d
```

## Files

- `install.sh` - Automated installation script for Docker and GitHub CLI
- `docker-compose.yml` - Service configuration
- `.env.example` - Environment template

## Installation Steps

The `install.sh` script will:

1. Install Docker and Docker Compose
2. Install GitHub CLI for easy authentication
3. Authenticate with GitHub Container Registry via browser
4. Copy `.env.example` to `.env`

## Configuration

Edit `.env` file with your credentials:

```env
# Application
APP_URL=http://localhost:3000
PORT=3000

# Database
DATABASE_URL=postgresql://username:password@host:port/database

# Storage
STORAGE_URL=https://storage.example.com
CDN_URL=https://cdn.example.com

# Cloudflare Tunnel (REQUIRED)
CLOUDFLARED_TOKEN=your_cloudflare_tunnel_token_here
```

## Management Commands

```bash
# Check status
docker compose ps

# View logs
docker compose logs -f

# Stop services
docker compose down

# Restart services
docker compose restart

# Update and restart
docker compose pull && docker compose up -d
```

## Architecture

```
┌──────────────┐     ┌─────────────────┐     ┌──────────────┐
│   Internet   │────▶│ Cloudflare      │────▶│     App      │
└──────────────┘     │    Tunnel       │     │   Container  │
                     └─────────────────┘     └──────────────┘
```

## Troubleshooting

### Docker permission denied
```bash
# Logout and login again after installation
# Or run: newgrp docker
```

### GitHub authentication failed
```bash
# Re-authenticate with GitHub
gh auth login -w
gh auth token | docker login ghcr.io -u $(gh api user -q .login) --password-stdin
```

### Container not starting
```bash
# Check logs
docker compose logs app
docker compose logs tunnel

# Verify environment variables
docker compose config
```

## Security

- Keep your `.env` file secure and never commit it
- Use strong passwords for database
- Regularly update Docker images
- Monitor Cloudflare Tunnel dashboard

## License

MIT