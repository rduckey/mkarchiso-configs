#!/usr/bin/env bash
set -e

NAME="$1"
BASE="${2:-releng}"

if [[ -z "$NAME" ]]; then
  echo "Usage: $0 <config-name> [releng|baseline]"
  exit 1
fi

DEST="configs/$NAME"
TEMPLATE="templates/$BASE"

[[ -d "$DEST" ]] && { echo "❌ Config $NAME already exists!"; exit 1; }
[[ ! -d "$TEMPLATE" ]] && { echo "❌ Base template $BASE does not exist!"; exit 1; }

echo "📁 Creating new config: $NAME (base: $BASE)..."

mkdir -p "$DEST"/{releng/overlay,scripts,overlays,presets}

# Base hint
echo "BASE_PROFILE=\"$BASE\"" > "$DEST/config.sh"

# Placeholder .env
touch "$DEST/.env"

# README
echo "# TODO: $NAME README" > "$DEST/README.md"

# packages.x86_64 (extends base)
cat << EOF > "$DEST/releng/overlay/packages.x86_64"
# Additional packages for $NAME
# These will be appended to the base template's packages.x86_64
EOF

# Copy archinstall.json if it exists in template
if [[ -f "$TEMPLATE/archinstall.json" ]]; then
  cp "$TEMPLATE/archinstall.json" "$DEST/presets/"
  echo "✅ Copied archinstall.json from $BASE"
else
  echo "{ }" > "$DEST/presets/archinstall.json"
fi

echo "✅ Created $DEST"
