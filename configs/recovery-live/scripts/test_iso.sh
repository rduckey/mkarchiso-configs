#!/bin/bash
set -euo pipefail

ISO_PATH="$HOME/arch-recovery-iso/out/archlinux-*.iso"

qemu-system-x86_64 \
  -m 4096 \
  -smp 4 \
  -cdrom "$ISO_PATH" \
  -boot d \
  -enable-kvm \
  -vga virtio \
  -nic user,model=virtio \
  -no-reboot
