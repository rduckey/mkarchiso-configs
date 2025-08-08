#!/usr/bin/env bash
set -e
echo "Running Repair NTFS Boot Sector..."
read -p "Enter NTFS partition (e.g., /dev/sda1): " dev
ntfsfix "$dev"
