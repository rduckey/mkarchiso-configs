#!/usr/bin/env bash
set -e
echo "Running NTFSFix..."
read -p "Enter NTFS device (e.g., /dev/sda1): " dev
ntfsfix "$dev"
