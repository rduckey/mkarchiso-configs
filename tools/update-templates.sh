#!/usr/bin/env bash
set -e

UPSTREAM_URL="https://github.com/archlinux/archiso.git"
TMP_REPO="/tmp/archiso-upstream-filtered"
TEMPLATES_DIR="$(dirname "$(realpath "$0")")/../templates"
VERSION_FILE="$TEMPLATES_DIR/.template-version"

echo "🔍 Checking for upstream changes..."

# Get latest commit hash from upstream master
LATEST_HASH=$(git ls-remote "$UPSTREAM_URL" refs/heads/master | cut -f1)

# If version file exists, compare hashes
if [[ -f "$VERSION_FILE" ]]; then
    CURRENT_HASH=$(grep "^upstream_commit=" "$VERSION_FILE" | cut -d= -f2)
    if [[ "$LATEST_HASH" == "$CURRENT_HASH" ]]; then
        echo "✅ Templates up to date"
        exit 0
    fi
fi

echo "🔁 Updating templates"

# Clone upstream repo shallowly
rm -rf "$TMP_REPO"
git clone --depth=1 "$UPSTREAM_URL" "$TMP_REPO"

# Filter only the needed folders
cd "$TMP_REPO"
git filter-repo --path configs/releng --path configs/baseline --force
cd -

# Replace templates with fresh content
rm -rf "$TEMPLATES_DIR/releng" "$TEMPLATES_DIR/baseline"
cp -r "$TMP_REPO/configs/releng" "$TEMPLATES_DIR/releng"
cp -r "$TMP_REPO/configs/baseline" "$TEMPLATES_DIR/baseline"

# Save version file
cat <<EOF > "$VERSION_FILE"
upstream_commit=$LATEST_HASH
last_sync=$(date -Iseconds)
EOF

echo "✅ Templates updated"
