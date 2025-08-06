#!/bin/bash
# TUI menu for CLI tools using dialog
MENU=$(dialog --stdout --title "CLI Recovery Tools" \
--menu "Choose an option" 20 60 10 \
1 "Restore Snapper Snapshot" \
2 "Repair Snapper Config" \
3 "Fix GRUB Bootloader" \
4 "Auto Chroot into System" \
5 "Run fsck on Unmounted Volumes" \
6 "Unlock LUKS Volume" \
7 "Reset Windows Password" \
8 "Mount BitLocker Drive")

case $MENU in
  1) ./scripts/restore_snapper.sh ;;
  2) ./scripts/repair_snapper.sh ;;
  3) ./scripts/fix_grub.sh ;;
  4) ./scripts/mount_and_chroot.sh ;;
  5) ./scripts/fsck_auto.sh ;;
  6) ./scripts/unlock_luks.sh ;;
  7) ./scripts/reset_windows_pass.sh ;;
  8) ./scripts/unlock_bitlocker.sh ;;
  *) clear ;;
esac