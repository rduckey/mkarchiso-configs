# Archinstall KDE dual-boot Btrfs snapshot preset

This is the safer dual-boot variant of `/root/archinstall-kde.json`. Use it
for systems that already have Windows installed and need Arch Linux installed
alongside it with Btrfs snapshots that can appear in GRUB.

## Design choices

- Uses the existing Windows EFI system partition and mounts it at `/efi`
  instead of creating or formatting a new ESP.
- Uses GRUB instead of systemd-boot so `os-prober` can add Windows entries
  and `grub-btrfs` can add snapshot entries.
- Uses a pre-mounted archinstall disk configuration so the Windows partitions
  are not modified by archinstall.
- Creates a Btrfs root with separate `@`, `@home`, `@log`, and `@pkg`
  subvolumes.
- Keeps `/boot` inside the Btrfs root so kernel and initramfs files are
  included in root snapshots.
- Installs `snapper`, `snap-pac`, `grub-btrfs`, `inotify-tools`, and
  `btrfs-assistant` for snapshot creation, pacman transaction snapshots,
  GRUB snapshot menu entries, and graphical snapshot management.

## Files

- `/root/prepare-dualboot-btrfs.sh` prepares the target partition, Btrfs
  subvolumes, and mount tree under `/mnt/archinstall`.
- `/root/archinstall-kde-dualboot-btrfs.json` tells archinstall to install
  into that pre-mounted tree and configure KDE, GRUB, Snapper, and grub-btrfs.

## Before running

Boot Windows first and use Windows Disk Management to shrink the Windows
partition. Leave the new space unallocated. Do not delete or format the Windows
EFI, Microsoft reserved, recovery, or Windows data partitions.

From the live ISO, find the stable disk and EFI partition paths:

```bash
lsblk -f
ls -l /dev/disk/by-id/
```

The EFI partition is usually a small FAT32 partition that Windows already uses.
The disk path should point to the whole disk, not a partition.

## Prepare the Btrfs target

Set these values before running the preparation script:

```bash
export TARGET_DISK=/dev/disk/by-id/YOUR_TARGET_DISK
export EFI_PARTITION=/dev/disk/by-id/YOUR_WINDOWS_ESP_PARTITION
export ARCH_START_MIB=REPLACE_WITH_FREE_SPACE_START_MIB
# Optional when the free space does not extend to the end of the disk:
# export ARCH_END=REPLACE_WITH_FREE_SPACE_END_MIBMiB
/root/prepare-dualboot-btrfs.sh
```

If you already created the Arch partition manually, skip `ARCH_START_MIB` and
provide it directly instead:

```bash
export TARGET_DISK=/dev/disk/by-id/YOUR_TARGET_DISK
export EFI_PARTITION=/dev/disk/by-id/YOUR_WINDOWS_ESP_PARTITION
export ARCH_PARTITION=/dev/disk/by-id/YOUR_ARCH_BTRFS_PARTITION
/root/prepare-dualboot-btrfs.sh
```

The script formats only the Arch partition as Btrfs, creates the subvolumes,
mounts them below `/mnt/archinstall`, and mounts the existing Windows EFI
partition at `/mnt/archinstall/efi`. If the unallocated space is not at the end
of the disk, set `ARCH_END` or create the Arch partition manually and use
`ARCH_PARTITION`.

## Credentials

Keep credentials out of this repository. Generate a separate
`/tmp/user_credentials.json` using archinstall's **Save configuration** flow, or
provide one that matches the archinstall version on the ISO.

## Run archinstall

```bash
archinstall --config /root/archinstall-kde-dualboot-btrfs.json --creds /tmp/user_credentials.json --silent
```

## After first boot

After booting into KDE, verify that GRUB sees Windows and snapshots:

```bash
sudo os-prober
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo snapper -c root list
```

Create a test snapshot before making risky changes:

```bash
sudo snapper -c root create --description "known-good KDE install"
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Restoring from snapshots

For quick recovery, reboot and select a snapshot from the GRUB snapshot submenu.
The `grub-btrfs-overlayfs` initramfs hook makes snapshot boots writable through
an overlay, which is useful for inspection and emergency repair.

For a permanent rollback, boot the main system or a live ISO, review the
snapshot you want, and use Snapper rollback from the installed system.
Regenerate GRUB afterward:

```bash
sudo snapper -c root rollback SNAPSHOT_NUMBER
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
