#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed. Install Docker Engine first." >&2
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Docker Compose v2 is not available. Install the Docker Compose plugin first." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker is installed, but this user cannot talk to the Docker daemon." >&2
  exit 1
fi

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env. Edit TS_AUTHKEY and PUBLIC_SSH_KEY, then rerun ./install.sh." >&2
  exit 1
fi

mkdir -p workspace data

docker compose up -d --build
docker compose exec devbox nvidia-smi
docker compose exec devbox tailscale ip -4

