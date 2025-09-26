# Docker Deploy Ubuntu

Quick Docker deployment script for Ubuntu servers with GitHub Container Registry support.

## Usage

```bash
# Clone specific branch for your project
git clone -b PROJECT_NAME https://github.com/nghyane/docker-deploy-ubuntu.git
cd docker-deploy-ubuntu

# Install Docker & authenticate
sudo bash install.sh

# Configure
nano .env

# Deploy
docker compose up -d
```

## Available Branches

- `main` - Base template
- `truyenqq` - TruyenQQ Clone deployment
- Create your own branch for custom projects

## Commands

```bash
docker compose ps       # Status
docker compose logs -f  # Logs
docker compose down     # Stop
docker compose restart  # Restart
```