#!/usr/bin/env bash
set -e

ISO_NAME="$1"
[[ -z "$ISO_NAME" ]] && { echo "Usage: $0 <iso-config-name>"; exit 1; }

PROJECT_ROOT="$(dirname "$(realpath "$0")")/.."
CONFIG_DIR="$PROJECT_ROOT/configs/$ISO_NAME"

# Source config to get base profile
source "$CONFIG_DIR/config.sh"
BASE_RELENG="$PROJECT_ROOT/templates/$BASE_PROFILE"
BUILD_DIR="/tmp/mkarchiso-$ISO_NAME-build"

echo "📦 Building ISO: $ISO_NAME"
echo "🔧 Using base profile: $BASE_PROFILE"
echo "📁 Base: $BASE_RELENG"
echo "📁 Overlay: $CONFIG_DIR/releng/overlay"

# Clean build dir
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy base template to working directory
cp -a "$BASE_RELENG/" "$BUILD_DIR/"

# Merge overlay files into base releng
if [[ -d "$CONFIG_DIR/releng/overlay" ]]; then
  echo "📁 Merging overlay into releng..."
  cp -ar "$CONFIG_DIR/releng/overlay/"* "$BUILD_DIR/" || true
fi

# Append packages
if [[ -f "$CONFIG_DIR/releng/overlay/packages.x86_64" ]]; then
  echo "📦 Appending extra packages to packages.x86_64..."
  cat "$CONFIG_DIR/releng/overlay/packages.x86_64" >> "$BUILD_DIR/packages.x86_64"
fi

# Build the ISO
mkarchiso -v -w "$BUILD_DIR/work" -o "$PROJECT_ROOT/out" "$BUILD_DIR"

echo "✅ Build complete: $PROJECT_ROOT/out/"
