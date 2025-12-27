#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

stop_one () {
  local name="$1"
  local pid_file="$ROOT_DIR/logs/${name}.pid"
  if [[ -f "$pid_file" ]]; then
    local pid
    pid="$(cat "$pid_file")"
    if kill -0 "$pid" >/dev/null 2>&1; then
      echo "[*] Stopping $name (pid=$pid)..."
      kill "$pid"
    fi
    rm -f "$pid_file"
  else
    echo "[*] $name pid file not found; skipping"
  fi
}

stop_one "frontend"
stop_one "proxy"
echo "[✓] Done."
