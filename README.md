# Production Setup

Quick Docker deployment scripts for production environments.

## Usage

### Option 1: Using Pre-built Image
```bash
# Clone repo
git clone https://github.com/nghyane/prodprod-setupsetup.git
cd prodprod-setupsetup

# Update docker-compose.yml with your image
nano docker-compose.yml
# Uncomment: image: your-image:tag

# Install Docker
sudo bash install.sh

# Configure
nano .env

# Deploy
docker compose up -d
```

### Option 2: Build from Source
```bash
# Clone your app repo
git clone YOUR_APP_REPO
cd YOUR_APP_REPO

# Copy setup files
curl -O https://raw.githubusercontent.com/nghyane/prod-setup/main/docker-compose.yml
curl -O https://raw.githubusercontent.com/nghyane/prod-setup/main/install.sh
curl -O https://raw.githubusercontent.com/nghyane/prod-setup/main/.env.example

# Create Dockerfile (if not exists)
cp Dockerfile.example Dockerfile
# Edit Dockerfile for your app

# Deploy
sudo bash install.sh
docker compose up -d --build
```

## Commands

```bash
docker compose ps       # Status
docker compose logs -f  # Logs
docker compose down     # Stop
docker compose restart  # Restart
docker compose build    # Rebuild
```

## Branches

- `main` - Base template
- Create your own branch for specific projects