#!/bin/bash
# ============================================================
# install-all.sh - Instalacion todo-en-uno de DaVinci Resolve + Fix AAC
# Uso: sudo ./scripts/install-all.sh
# ============================================================
set -e

echo "============================================"
echo "  DaVinci Resolve + AAC Fix - Instalador"
echo "============================================"
echo ""

# --- Verificar root ---
if [ "$EUID" -ne 0 ]; then
  echo "Error: Ejecuta este script como root (sudo)"
  exit 1
fi

# --- Buscar instalador de DaVinci Resolve ---
RESOLVE installer=""
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

for f in "$REPO_DIR"/DaVinci_Resolve_Studio_*.run "$REPO_DIR"/DaVinci_Resolve_*.run; do
  if [ -f "$f" ]; then
    RESOLVE_INSTALLER="$f"
    break
  fi
done

if [ -z "$RESOLVE_INSTALLER" ]; then
  echo "No se encontro el instalador de DaVinci Resolve."
  echo ""
  echo "Descarga el instalador oficial desde:"
  echo "  https://www.blackmagicdesign.com/products/davinciresolve"
  echo ""
  echo "Coloca el archivo .run en la raiz del repo y vuelve a ejecutar este script."
  exit 1
fi

echo "[1/4] Instalando dependencias..."
if command -v apt >/dev/null 2>&1; then
  apt update -y
  apt install -y build-essential pkg-config libavcodec-dev libavutil-dev ffmpeg clang
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y clang pkgconfig ffmpeg-devel make
else
  echo "Warning: No se pudo detectar el gestor de paquetes."
  echo "Asegurate de tener instalado: clang, ffmpeg, ffmpeg-devel, make"
fi

echo ""
echo "[2/4] Instalando DaVinci Resolve..."
echo "Instalador: $RESOLVE_INSTALLER"
chmod +x "$RESOLVE_INSTALLER"
"$RESOLVE_INSTALLER" -i

echo ""
echo "[3/4] Compilando plugin AAC..."
cd "$REPO_DIR/aac-plugin"
./build.sh

echo ""
echo "[4/4] Instalando plugin AAC..."
./install.sh

echo ""
echo "============================================"
echo "  Instalacion completa!"
echo "============================================"
echo ""
echo "DaVinci Resolve Studio instalado en /opt/resolve"
echo "Plugin AAC instalado en /opt/resolve/IOPlugins/"
echo ""
echo "Abre DaVinci Resolve Studio > Deliver > MP4"
echo "y selecciona 'AAC (FFMpeg Plugin)' como codec de audio."
