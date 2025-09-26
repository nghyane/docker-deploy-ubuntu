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
IMAGE="ghcr.io/nghyane/truyenqq-clone:latestlatest"

if docker pull "$IMAGE" &>/dev/null 2>&1; then
    echo "✓ Already authenticated to GitHub Container Registry"
else
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

    # Verify login worked with detailed error
    echo "Verifying authentication..."
    echo "Attempting to pull: $IMAGE"

    if docker pull "$IMAGE"; then
        echo "✓ Authentication successful!"
    else
        echo ""
        echo "❌ Failed to pull image. Possible issues:"
        echo "1. Image doesn't exist with tag 'latest'"
        echo "2. Package visibility needs to be set to public"
        echo "3. Token doesn't have 'read:packages' permission"
        echo ""
        echo "Debug info:"
        docker pull "$IMAGE" 2>&1 | tail -5
        echo ""
        echo "Try:"
        echo "- Check if image exists at: https://github.com/nghyane/truyenqq-clone/pkgs/container/truyenqq-clone"
        echo "- Verify package is public or you have access"
        echo "- Use a different tag if 'latest' doesn't exist"
        exit 1
    fi
fi

docker --version && docker compose version

# Copy .env.example to .env if not exists
[ -f .env.example ] && [ ! -f .env ] && cp .env.example .env && echo "Created .env from .env.example - Please add your CLOUDFLARED_TOKEN"

echo ""
echo "✓ Setup complete! Run 'docker compose up -d' to start services."
