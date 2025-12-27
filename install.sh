#!/usr/bin/env bash
set -euo pipefail

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR"

PYTHON_BIN="${PYTHON_BIN:-python3}"
CALYPSO_WHEEL_URL_DEFAULT="https://docs.calypsoai.com/calypsoai-2.72.4-py3-none-any.whl"
CALYPSO_WHEEL_URL="${CALYPSO_WHEEL_URL:-$CALYPSO_WHEEL_URL_DEFAULT}"

echo "[*] App dir: $APP_DIR"
echo "[*] Python  : $PYTHON_BIN"

command -v "$PYTHON_BIN" >/dev/null 2>&1 || { echo "ERROR: python3 not found"; exit 1; }

# Basic sanity checks
test -d frontend || { echo "ERROR: missing ./frontend"; exit 1; }
test -d proxy || { echo "ERROR: missing ./proxy"; exit 1; }

# Create env file if missing
if [[ ! -f ".env" ]]; then
  if [[ -f "env.example" ]]; then
    cp env.example .env
    echo "[!] Created .env from env.example. Please edit .env with real values."
  else
    echo "[!] No env.example found; please create .env manually."
  fi
fi

echo "[*] Creating venvs..."
"$PYTHON_BIN" -m venv .venv-frontend
"$PYTHON_BIN" -m venv .venv-proxy

echo "[*] Installing frontend deps..."
./.venv-frontend/bin/python -m pip install --upgrade pip wheel setuptools
./.venv-frontend/bin/python -m pip install -r frontend/requirements.txt

echo "[*] Installing proxy deps..."
./.venv-proxy/bin/python -m pip install --upgrade pip wheel setuptools
./.venv-proxy/bin/python -m pip install -r proxy/requirements.txt

echo "[*] Installing Calypso wheel..."
./.venv-proxy/bin/python -m pip install "$CALYPSO_WHEEL_URL" || {
  echo "ERROR: Failed to install Calypso wheel from:"
  echo "       $CALYPSO_WHEEL_URL"
  echo "Tip: export CALYPSO_WHEEL_URL=<new-url> and rerun install.sh"
  exit 1
}

echo ""
echo "[✓] Install complete."
echo "Next:"
echo "  1) Edit .env"
echo "  2) Run: ./run.sh"
