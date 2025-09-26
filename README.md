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
