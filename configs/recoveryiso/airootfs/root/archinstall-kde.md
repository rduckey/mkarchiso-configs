# Archinstall KDE workstation preset

This preset is copied into the live ISO as `/root/archinstall-kde.json` and is intended for `archinstall` guided installs that should finish at a KDE Plasma desktop login screen.

## What it installs

- UEFI boot with systemd-boot.
- A wiped target disk with a 1 GiB FAT32 `/boot` partition and an ext4 `/` partition using the rest of the disk.
- The `linux` and `linux-lts` kernels, PipeWire audio, zram swap, NTP, and the `multilib` repository.
- The archinstall `Desktop` profile with `KDE Plasma`, the `sddm` greeter, and open-source graphics drivers.
- Common workstation packages including Firefox, Dolphin, Konsole, Kate, NetworkManager, Bluetooth tools, CUPS, sudo, git, vim, wget, and base-devel.
- Services for SDDM, NetworkManager, Bluetooth, and CUPS.

## Before running

The JSON deliberately uses this placeholder disk path so it cannot wipe a real disk until you edit it:

```json
"device": "/dev/disk/by-id/REPLACE_WITH_TARGET_DISK"
```

Find the stable disk path for the install target:

```bash
ls -l /dev/disk/by-id/
```

Copy the preset to a writable path and replace the placeholder with the disk you want to erase:

```bash
cp /root/archinstall-kde.json /tmp/archinstall-kde.json
sed -i 's#/dev/disk/by-id/REPLACE_WITH_TARGET_DISK#/dev/disk/by-id/YOUR_TARGET_DISK#g' /tmp/archinstall-kde.json
```

Review the timezone, hostname, keyboard layout, locale, partition layout, kernel choices, packages, and services before running it.

## Credentials

Keep credentials out of this repository. Generate a separate `/tmp/user_credentials.json` using archinstall's **Save configuration** flow, or provide one that matches the archinstall version on the ISO. Current archinstall releases use a separate credentials file for user and root password hashes.

## Run

```bash
archinstall --config /tmp/archinstall-kde.json --creds /tmp/user_credentials.json --silent
```

If your ISO ships an older archinstall version, generate a fresh config with that version first:

```bash
archinstall --dry-run
```

Then compare the saved `/var/log/archinstall/user_configuration.json` with this preset and adjust field names as needed.
