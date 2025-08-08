#!/usr/bin/env bash
set -e
echo "Running chntpw..."
read -p "Enter path to Windows SAM file (e.g., /mnt/Windows/System32/config/SAM): " samfile
chntpw -i "$samfile"
