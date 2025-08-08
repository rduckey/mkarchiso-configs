#!/usr/bin/env bash
# Script to display drive information and offer simple mount/chroot actions

set -euo pipefail

# Display header
printf "\n===== Drive Information =====\n"

# List block devices with sizes and filesystems
if command -v lsblk >/dev/null 2>&1; then
    lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINT
fi

# Show blkid info if available
if command -v blkid >/dev/null 2>&1; then
    echo "\nblkid information:"
    blkid -c /dev/null || true
fi

# Check if dialog or whiptail is available for interactive menu
function ask_yes_no() {
    local prompt="$1"
    if command -v whiptail >/dev/null 2>&1; then
        whiptail --yesno "$prompt" 10 60 && return 0 || return 1
    elif command -v dialog >/dev/null 2>&1; then
        dialog --yesno "$prompt" 10 60 && return 0 || return 1
    else
        read -p "$prompt [y/N]: " ans
        [[ "$ans" =~ ^[Yy]$ ]]
    fi
}

function ask_input() {
    local prompt="$1"
    local default_value="$2"
    if command -v whiptail >/dev/null 2>&1; then
        whiptail --inputbox "$prompt" 10 60 "$default_value" 3>&1 1>&2 2>&3
    elif command -v dialog >/dev/null 2>&1; then
        dialog --inputbox "$prompt" 10 60 "$default_value" 3>&1 1>&2 2>&3
    else
        read -p "$prompt [$default_value]: " ans
        echo "${ans:-$default_value}"
    fi
}

# Ask user if they want to mount a partition
if ask_yes_no "Would you like to mount a partition?"; then
    device=$(ask_input "Enter the device (e.g., /dev/sda1):" "/dev/sda1")
    mountpoint=$(ask_input "Enter mount point (default /mnt):" "/mnt")
    mkdir -p "$mountpoint"
    if mount | grep -q "^$device"; then
        echo "$device is already mounted."
    else
        echo "Mounting $device to $mountpoint..."
        if mount "$device" "$mountpoint"; then
            echo "Mounted successfully."
        else
            echo "Failed to mount $device."
        fi
    fi
    # Ask if user wants to chroot into system
    if ask_yes_no "Would you like to chroot into the mounted system?"; then
        if command -v arch-chroot >/dev/null 2>&1; then
            echo "Launching arch-chroot on $mountpoint..."
            arch-chroot "$mountpoint" /bin/bash
        else
            echo "arch-chroot not found; falling back to chroot..."
            chroot "$mountpoint" /bin/bash
        fi
    fi
fi

exit 0
