# GPU Devbox

Ubuntu CUDA container with SSH and Tailscale, intended for temporary remote access to a GPU workstation.

The host must already have:

- NVIDIA drivers
- Docker Engine with Docker Compose v2
- NVIDIA Container Toolkit configured for Docker

## Setup

Create `.env`:

```bash
cp .env.example .env
```

Edit:

- `TS_AUTHKEY`: a preauthorized Tailscale auth key from your tailnet
- `PUBLIC_SSH_KEY`: your SSH public key
- `TS_HOSTNAME`: the Tailscale device name

Start it:

```bash
./install.sh
```

Or directly:

```bash
mkdir -p workspace data
docker compose up -d --build
```

Get the Tailscale IP:

```bash
docker compose exec devbox tailscale ip -4
```

SSH in:

```bash
ssh root@TAILSCALE_IP
```

## Persistence

- Tailscale identity persists in the `tailscale-state` Docker volume.
- SSH host keys persist in the `ssh-host-keys` Docker volume.
- Work goes in `./workspace`, bind-mounted to `/workspace`.
- Large data goes in `./data`, bind-mounted to `/data`.

Deleting the container is fine. Do not delete the volumes unless you want to reset identity/host keys.

## GPU Check

```bash
docker compose exec devbox nvidia-smi
```

If this fails, the host probably needs NVIDIA Container Toolkit installed or configured.

