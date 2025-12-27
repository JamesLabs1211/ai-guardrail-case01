#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR"

if [[ ! -f ".env" ]]; then
  echo "ERROR: .env not found. Copy env.example to .env and fill values."
  exit 1
fi

# Load env vars (simple .env format: KEY="VALUE")
set -a
source .env
set +a

# Basic checks
[[ -x "./.venv-proxy/bin/python" ]] || { echo "ERROR: proxy venv missing. Run ./install.sh"; exit 1; }
[[ -x "./.venv-frontend/bin/python" ]] || { echo "ERROR: frontend venv missing. Run ./install.sh"; exit 1; }

echo "[*] Starting Guardrail Proxy on :18080 ..."
nohup ./.venv-proxy/bin/uvicorn proxy.app:app --host 0.0.0.0 --port 18080 \
  > proxy.log 2>&1 &

sleep 1

echo "[*] Starting Frontend on :5000 ..."
nohup ./.venv-frontend/bin/python frontend/main_chat.py \
  > frontend.log 2>&1 &

echo ""
echo "[✓] Started."
echo "Proxy log    : $APP_DIR/proxy.log"
echo "Frontend log : $APP_DIR/frontend.log"
echo ""
echo "Health check (proxy):"
echo "  curl http://127.0.0.1:18080/health"
echo ""
echo "UI:"
echo "  http://<server-ip>:5000"
