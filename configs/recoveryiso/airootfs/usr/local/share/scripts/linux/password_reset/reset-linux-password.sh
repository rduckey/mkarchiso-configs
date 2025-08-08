#!/usr/bin/env bash
set -e
echo "Running Reset Linux Password..."
read -p "Enter root partition device (e.g., /dev/sda2): " rootdev
read -p "Enter mount point (default /mnt): " mnt
mnt=${mnt:-/mnt}
mkdir -p "$mnt"
mount "$rootdev" "$mnt"
arch-chroot "$mnt" bash -c "read -p "Enter username to reset: " user; passwd \$user"
umount -R "$mnt"
