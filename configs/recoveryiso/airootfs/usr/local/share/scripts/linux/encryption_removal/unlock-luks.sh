#!/usr/bin/env bash
set -e
echo "Running Unlock LUKS..."
read -p "Enter LUKS device (e.g., /dev/sda3): " luksdev
read -p "Enter mapping name (e.g., cryptroot): " mapname
cryptsetup open "$luksdev" "$mapname"
echo "Unlocked as /dev/mapper/$mapname"
