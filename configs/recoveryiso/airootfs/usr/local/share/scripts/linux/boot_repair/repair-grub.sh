#!/usr/bin/env bash
set -e
echo "Running GRUB Repair..."
echo "This script will mount a Linux partition and reinstall GRUB."
read -p "Enter the root device (e.g., /dev/sda2): " rootdev
read -p "Enter mount point (default /mnt): " mnt
mnt=${mnt:-/mnt}
mkdir -p "$mnt"
mount "$rootdev" "$mnt"
mount --bind /dev "$mnt/dev"
mount --bind /proc "$mnt/proc"
mount --bind /sys "$mnt/sys"
chroot "$mnt" grub-install "$rootdev"
chroot "$mnt" grub-mkconfig -o /boot/grub/grub.cfg
umount -R "$mnt"
echo "GRUB has been repaired."
