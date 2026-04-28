#!/usr/bin/env bash
set -euo pipefail

if [[ -n "${PUBLIC_SSH_KEY:-}" ]]; then
  install -d -m 700 /root/.ssh
  printf '%s\n' "${PUBLIC_SSH_KEY}" > /root/.ssh/authorized_keys
  chmod 600 /root/.ssh/authorized_keys
fi

ssh-keygen -A

if [[ ! -e /dev/net/tun ]]; then
  echo "Missing /dev/net/tun. Check the compose devices section." >&2
  exit 1
fi

tailscaled --state=/var/lib/tailscale/tailscaled.state &
TAILSCALED_PID="$!"

cleanup() {
  kill "${TAILSCALED_PID}" 2>/dev/null || true
}
trap cleanup EXIT

for _ in $(seq 1 30); do
  if tailscale status >/dev/null 2>&1 || tailscale status 2>&1 | grep -qi 'Logged out'; then
    break
  fi
  sleep 1
done

if ! tailscale status >/dev/null 2>&1; then
  if [[ -z "${TS_AUTHKEY:-}" ]]; then
    echo "Tailscale is not logged in and TS_AUTHKEY is not set." >&2
    exit 1
  fi

  tailscale up \
    --auth-key="${TS_AUTHKEY}" \
    --hostname="${TS_HOSTNAME:-gpu-devbox}" \
    --accept-dns=false
fi

exec /usr/sbin/sshd -D -e

