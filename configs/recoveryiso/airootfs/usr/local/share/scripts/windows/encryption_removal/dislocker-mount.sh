#!/usr/bin/env bash
set -e
echo "Running Dislocker (BitLocker)..."
read -p "Enter BitLocker device (e.g., /dev/sda3): " bitdev
read -p "Enter mount point for decrypted volume (default /mnt/bitlocker): " mnt
mnt=${mnt:-/mnt/bitlocker}
mkdir -p "$mnt"
dislocker -V "$bitdev" -u -- /mnt/dislocker
mkdir -p "$mnt"
mount -o loop /mnt/dislocker/dislocker-file "$mnt"
echo "Mounted BitLocker volume at $mnt"
