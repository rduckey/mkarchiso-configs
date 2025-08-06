#!/usr/bin/env bash
set -e

cd "$(dirname "$(realpath "$0")")/.."

echo "🔁 Updating templates from upstream archiso..."

git subtree pull --prefix=templates/releng https://github.com/archlinux/archiso.git master --squash --path=configs/releng
git subtree pull --prefix=templates/baseline https://github.com/archlinux/archiso.git master --squash --path=configs/baseline
