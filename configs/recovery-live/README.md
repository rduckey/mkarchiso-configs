# Arch Recovery ISO

This is a fully-featured Arch-based recovery ISO with tools for Linux, Windows, Android, and encrypted systems.

## Features

- XFCE Desktop Environment
- Snapper + Timeshift support
- BitLocker and LUKS decryption (dislocker, libbde-utils, cryptsetup)
- Android ADB + flashing tools
- Windows recovery (password reset, boot repair, file access)
- Clonezilla GUI frontend
- GUI + TUI unified recovery toolkit menu
- Automatic mounting, chroot, and repair scripts

## Directory Structure

- `releng/` — ArchISO profile files
- `tools/` — Scripts to build and test ISO

## Build Instructions

```bash
./tools/build_iso.sh
```

## Test in QEMU

```bash
./tools/test_iso.sh
```

Ensure `mkarchiso` and `qemu-system-x86_64` are installed.