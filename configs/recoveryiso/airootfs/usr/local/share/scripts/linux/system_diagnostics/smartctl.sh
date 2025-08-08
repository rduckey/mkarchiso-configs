#!/usr/bin/env bash
set -e
echo "Running smartctl..."
read -p "Enter device (e.g., /dev/sda): " device
smartctl --all "$device"
