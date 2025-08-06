#!/usr/bin/env bash
ISO="$1"
[[ -z "$ISO" ]] && { echo "Usage: $0 <path-to-iso>"; exit 1; }
qemu-system-x86_64 -m 4096 -cdrom "$ISO" -boot d -enable-kvm -vga virtio
