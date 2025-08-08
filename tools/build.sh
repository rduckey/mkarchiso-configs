#!/usr/bin/env bash
set -e

PROJECT_ROOT="$(dirname "$(realpath "$0")")/.."
CONFIGS_DIR="$PROJECT_ROOT/configs"
TEMPLATES_DIR="$PROJECT_ROOT/templates"
UPDATE_SCRIPT="$PROJECT_ROOT/tools/update-templates.sh"

# Update templates (skips if already up-to-date)
"$UPDATE_SCRIPT"

# Get list of configs
mapfile -t CONFIG_NAMES < <(find "$CONFIGS_DIR" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

# Show menu
echo "Select configs to build:"
for i in "${!CONFIG_NAMES[@]}"; do
  printf " [%d] %s\n" "$((i+1))" "${CONFIG_NAMES[$i]}"
done
echo " [A] All"

# Prompt input
read -rp "> " SELECTION

# Normalize input
SELECTION=$(echo "$SELECTION" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')

# Determine which configs to build
BUILD_LIST=()

if [[ "$SELECTION" == "a" ]]; then
  BUILD_LIST=("${CONFIG_NAMES[@]}")
else
  IFS=',' read -ra INDEXES <<< "$SELECTION"
  for index in "${INDEXES[@]}"; do
    if [[ "$index" =~ ^[0-9]+$ ]] && (( index >= 1 && index <= ${#CONFIG_NAMES[@]} )); then
      BUILD_LIST+=("${CONFIG_NAMES[$((index-1))]}")
    else
      echo "❌ Invalid selection: $index"
      exit 1
    fi
  done
fi

# Confirm
echo "🔨 Building configs: ${BUILD_LIST[*]}"

# Build each selected config
for ISO_NAME in "${BUILD_LIST[@]}"; do
  echo -e "\n🚧 Building: $ISO_NAME"
  CONFIG_DIR="$CONFIGS_DIR/$ISO_NAME"

  source "$CONFIG_DIR/config.sh"
  BASE_RELENG="$TEMPLATES_DIR/$BASE_PROFILE"
  BUILD_DIR="/tmp/mkarchiso-$ISO_NAME-build"

  echo "📦 Using base: $BASE_PROFILE"

  rm -rf "$BUILD_DIR"
  mkdir -p "$BUILD_DIR"

  cp -a "$BASE_RELENG/" "$BUILD_DIR/"

  if [[ -d "$CONFIG_DIR/releng/overlay" ]]; then
    echo "📁 Applying overlay..."
    cp -ar "$CONFIG_DIR/releng/overlay/"* "$BUILD_DIR/" || true
  fi

  if [[ -f "$CONFIG_DIR/releng/overlay/packages.x86_64" ]]; then
    echo "📦 Appending packages..."
    cat "$CONFIG_DIR/releng/overlay/packages.x86_64" >> "$BUILD_DIR/packages.x86_64"
  fi

  mkarchiso -v -w "$BUILD_DIR/work" -o "$PROJECT_ROOT/out" "$BUILD_DIR"

  echo "✅ Finished build: $ISO_NAME"
done
