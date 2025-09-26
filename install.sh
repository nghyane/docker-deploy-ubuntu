#!/bin/bash
# Install Docker on Ubuntu

[[ $EUID -ne 0 ]] && { echo "Run with sudo"; exit 1; }

# Install Docker first if not available
if ! command -v docker &>/dev/null; then
    echo "Installing Docker..."
    apt-get update
    apt-get install -y ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    systemctl enable --now docker
    [ -n "$SUDO_USER" ] && usermod -aG docker $SUDO_USER
fi

# Install GitHub CLI if not exists
if ! command -v gh &>/dev/null; then
    echo "Installing GitHub CLI..."
    apt-get update && apt-get install -y gh
fi

# Check if already logged into GitHub Container Registry
echo "Checking GitHub Container Registry access..."
if ! docker pull ghcr.io/nghiahoang/truyenqq-clone:latest &>/dev/null 2>&1; then
    echo ""
    echo "========================================="
    echo "GitHub Container Registry Login Required"
    echo "========================================="
    echo ""

    # Check if already authenticated with gh
    if gh auth status &>/dev/null 2>&1; then
        echo "GitHub CLI already authenticated, logging into Docker registry..."
        gh auth token | docker login ghcr.io -u $(gh api user -q .login) --password-stdin
    else
        echo "Opening browser for GitHub login..."
        gh auth login -h github.com -p https -w
        echo "Logging into Docker registry..."
        gh auth token | docker login ghcr.io -u $(gh api user -q .login) --password-stdin
    fi

    # Verify login worked
    echo "Verifying authentication..."
    if ! docker pull ghcr.io/nghiahoang/truyenqq-clone:latest &>/dev/null 2>&1; then
        echo "Authentication failed. Please try again."
        exit 1
    fi
    echo "✓ Authentication successful!"
else
    echo "✓ Already authenticated to GitHub Container Registry"
fi

docker --version && docker compose version

# Copy .env.example to .env if not exists
[ -f .env.example ] && [ ! -f .env ] && cp .env.example .env && echo "Created .env from .env.example - Please add your CLOUDFLARED_TOKEN"

echo ""
echo "✓ Setup complete! Run 'docker compose up -d' to start services."
