#!/usr/bin/env bash
set -euo pipefail

: "${TARGET_DISK:=/dev/disk/by-id/REPLACE_WITH_TARGET_DISK}"
: "${EFI_PARTITION:=/dev/disk/by-id/REPLACE_WITH_WINDOWS_ESP_PARTITION}"
: "${ARCH_PARTITION:=}"
: "${ARCH_START_MIB:=REPLACE_WITH_FREE_SPACE_START_MIB}"
: "${ARCH_END:=100%}"
: "${MOUNTPOINT:=/mnt/archinstall}"
: "${BTRFS_LABEL:=ARCHLINUX}"

fail() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

require_real_value() {
  local name="$1"
  local value="$2"

  [[ -n "$value" ]] || fail "$name is empty"
  [[ "$value" != *REPLACE_WITH* ]] || fail "$name still contains a placeholder: $value"
}

require_block_device() {
  local name="$1"
  local value="$2"

  require_real_value "$name" "$value"
  [[ -b "$value" ]] || fail "$name does not point to a block device: $value"
}

require_block_device TARGET_DISK "$TARGET_DISK"
require_block_device EFI_PARTITION "$EFI_PARTITION"

if [[ -z "$ARCH_PARTITION" ]]; then
  require_real_value ARCH_START_MIB "$ARCH_START_MIB"
  mapfile -t before_partitions < <(lsblk --paths --noheadings --output NAME,TYPE "$TARGET_DISK" | awk '$2 == "part" {print $1}' | sort)
  printf 'Creating a new Linux Btrfs partition on %s from %sMiB to %s.\n' "$TARGET_DISK" "$ARCH_START_MIB" "$ARCH_END"
  parted --script "$TARGET_DISK" mkpart "Arch Linux Btrfs" btrfs "${ARCH_START_MIB}MiB" "$ARCH_END"
  partprobe "$TARGET_DISK"
  sleep 2
  mapfile -t after_partitions < <(lsblk --paths --noheadings --output NAME,TYPE "$TARGET_DISK" | awk '$2 == "part" {print $1}' | sort)
  ARCH_PARTITION="$(comm -13 <(printf '%s\n' "${before_partitions[@]}") <(printf '%s\n' "${after_partitions[@]}") | tail -n 1)"
  [[ -n "$ARCH_PARTITION" ]] || fail 'Unable to detect the newly-created Arch partition; set ARCH_PARTITION manually and rerun.'
else
  require_block_device ARCH_PARTITION "$ARCH_PARTITION"
fi

require_block_device ARCH_PARTITION "$ARCH_PARTITION"

printf 'Formatting %s as Btrfs with label %s.\n' "$ARCH_PARTITION" "$BTRFS_LABEL"
mkfs.btrfs --force --label "$BTRFS_LABEL" "$ARCH_PARTITION"

workdir="$(mktemp -d)"
trap 'umount -R "$workdir" >/dev/null 2>&1 || true; rmdir "$workdir" >/dev/null 2>&1 || true' EXIT

mount "$ARCH_PARTITION" "$workdir"
for subvolume in @ @home @log @pkg; do
  btrfs subvolume create "$workdir/$subvolume"
done
umount "$workdir"

mount_options='noatime,compress=zstd:3,space_cache=v2'
mkdir -p "$MOUNTPOINT"
mount -o "${mount_options},subvol=@" "$ARCH_PARTITION" "$MOUNTPOINT"
mkdir -p "$MOUNTPOINT"/{efi,home,var/log,var/cache/pacman/pkg}
mount -o "${mount_options},subvol=@home" "$ARCH_PARTITION" "$MOUNTPOINT/home"
mount -o "${mount_options},subvol=@log" "$ARCH_PARTITION" "$MOUNTPOINT/var/log"
mount -o "${mount_options},subvol=@pkg" "$ARCH_PARTITION" "$MOUNTPOINT/var/cache/pacman/pkg"
mount "$EFI_PARTITION" "$MOUNTPOINT/efi"

cat <<SUMMARY

Prepared the dual-boot Btrfs target at $MOUNTPOINT.

Next steps:
  1. Confirm Windows still owns the EFI system partition mounted at $MOUNTPOINT/efi.
  2. Create or copy your archinstall credentials file.
  3. Run:
     archinstall --config /root/archinstall-kde-dualboot-btrfs.json --creds /tmp/user_credentials.json --silent

SUMMARY
