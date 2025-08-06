#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${SCRIPT_DIR}"
RELENG_DIR="${PROJECT_DIR}/releng"
OUT_DIR="${PROJECT_DIR}/out"

echo "🔨 Building Arch Recovery ISO..."
sudo mkarchiso -v -w "${RELENG_DIR}/work" -o "${OUT_DIR}" "${RELENG_DIR}"
echo "✅ ISO created in ${OUT_DIR}"
