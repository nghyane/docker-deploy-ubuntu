# Production Setup

Quick Docker deployment scripts for production environments.

## Usage

```bash
# Clone specific branch for your project
git clone -b PROJECT_NAME https://github.com/nghyane/prod-setup.git
cd prod-setup

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