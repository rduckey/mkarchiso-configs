#!/usr/bin/env bash
set -e

ISO_NAME="$1"
[[ -z "$ISO_NAME" ]] && { echo "Usage: $0 <iso-config-name>"; exit 1; }

PROJECT_ROOT="$(dirname "$(realpath "$0")")/.."
CONFIG_DIR="$PROJECT_ROOT/configs/$ISO_NAME"

# Refresh templates before build
"$PROJECT_ROOT/tools/update-templates.sh"

# Source base profile
source "$CONFIG_DIR/config.sh"
BASE_RELENG="$PROJECT_ROOT/templates/$BASE_PROFILE"
BUILD_DIR="/tmp/mkarchiso-$ISO_NAME-build"

echo "📦 Building ISO: $ISO_NAME using base: $BASE_PROFILE"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cp -a "$BASE_RELENG/" "$BUILD_DIR/"

# Merge overlay
if [[ -d "$CONFIG_DIR/releng/overlay" ]]; then
  echo "📁 Applying overlay..."
  cp -ar "$CONFIG_DIR/releng/overlay/"* "$BUILD_DIR/" || true
fi

# Append extra packages
if [[ -f "$CONFIG_DIR/releng/overlay/packages.x86_64" ]]; then
  echo "📦 Appending packages..."
  cat "$CONFIG_DIR/releng/overlay/packages.x86_64" >> "$BUILD_DIR/packages.x86_64"
fi

mkarchiso -v -w "$BUILD_DIR/work" -o "$PROJECT_ROOT/out" "$BUILD_DIR"

echo "✅ ISO build complete"
