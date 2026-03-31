#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/www/server/xpanel"
TMP_DIR="$(mktemp -d /tmp/xpanel-public-install.XXXXXX)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if [[ "$EUID" -ne 0 ]]; then
  echo "[ERRO] Execute como root"
  exit 1
fi

VERSION="${XPANEL_VERSION:?Defina XPANEL_VERSION}"
RELEASE_BASE_URL="${XPANEL_RELEASE_BASE_URL:?Defina XPANEL_RELEASE_BASE_URL}"
ARCHIVE_URL="${XPANEL_ARCHIVE_URL:-$RELEASE_BASE_URL/xpanel-${VERSION}.tar.gz}"

echo "[1/4] Baixando release $VERSION ..."
curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/xpanel.tar.gz"

echo "[2/4] Extraindo pacote ..."
mkdir -p "$TMP_DIR/src"
tar -xzf "$TMP_DIR/xpanel.tar.gz" -C "$TMP_DIR/src"

echo "[3/4] Executando instalador do pacote ..."
cd "$TMP_DIR/src"
XPANEL_RELEASE_INSTALL=1 bash scripts/install.sh

echo "[4/4] Instalacao concluida em $BASE_DIR"
