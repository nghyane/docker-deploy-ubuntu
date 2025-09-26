# Cloudflare Tunnel Setup Guide

## Quick Setup (Recommended)

### 1. Login to Cloudflare Dashboard
https://one.dash.cloudflare.com/

### 2. Create Tunnel
1. Go to **Zero Trust** → **Networks** → **Tunnels**
2. Click **"Create a tunnel"**
3. Choose **"Cloudflared"** 
4. Name your tunnel (e.g., `truyenqq-prod`)
5. Click **Save tunnel**

### 3. Get Token
1. After creating, you'll see installation instructions
2. Choose **"Docker"** tab
3. Copy the token from the docker run command:
```bash
docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token eyJhIjoiY2MzMj...
```
4. Copy only the token part (starts with `eyJ...`)

### 4. Configure Public Hostname
1. Click **"Configure"** on your tunnel
2. Add public hostname:
   - **Subdomain**: `app` (or your choice)
   - **Domain**: Select your domain
   - **Service**: `http://app:3000`
   - **Type**: HTTP
3. Save

### 5. Add Token to .env
```env
CLOUDFLARED_TOKEN=eyJhIjoiY2MzMj...your_token_here
```

## Alternative: CLI Method

```bash
# Install cloudflared
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o cloudflared
chmod +x cloudflared
sudo mv cloudflared /usr/local/bin

# Login
cloudflared tunnel login

# Create tunnel
cloudflared tunnel create truyenqq-prod

# Get token
cloudflared tunnel token truyenqq-prod
```

## Verify Tunnel

After `docker compose up -d`:

1. Check tunnel status in Cloudflare Dashboard
2. Look for green "HEALTHY" status
3. Visit your configured hostname

## Multiple Services

To expose multiple services through one tunnel:

1. In Cloudflare Dashboard → Your Tunnel → Configure
2. Add more public hostnames:
   - `api.yourdomain.com` → `http://api:4000`
   - `admin.yourdomain.com` → `http://admin:5000`

## Troubleshooting

### Tunnel shows "INACTIVE"
```bash
docker compose logs tunnel
```

### Connection refused
- Check if app container is running: `docker ps`
- Verify service name matches in docker-compose.yml
- Ensure PORT in .env matches app configuration

### Domain not working
- Wait 1-2 minutes for DNS propagation
- Check DNS records in Cloudflare Dashboard
- Verify tunnel is "HEALTHY" status

## Security Tips

1. **Never commit token** - Keep in .env only
2. **Use Access policies** - Add authentication in Zero Trust → Access
3. **Enable WAF** - Protect against attacks
4. **Monitor logs** - Check tunnel metrics in dashboard