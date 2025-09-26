#!/bin/bash
# Install Docker on Ubuntu

[[ $EUID -ne 0 ]] && { echo "Run with sudo"; exit 1; }

# Install Docker if not available
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

docker --version && docker compose version

# Copy .env.example to .env if not exists
[ -f .env.example ] && [ ! -f .env ] && cp .env.example .env && echo "Created .env from .env.example - Please add your CLOUDFLARED_TOKEN"

echo ""
echo "✓ Setup complete! Run 'docker compose up -d' to start services."
