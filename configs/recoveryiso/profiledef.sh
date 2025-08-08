#!/usr/bin/env bash
# shellcheck disable=SC2034
# Custom profile definition for System Recovery ISO
iso_name="recovery"
iso_label="RECOVERY_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="System Recovery Project <https://example.com>"
iso_application="System Recovery and Repair Live Media"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="recovery"
buildmodes=('iso')
# Support BIOS (syslinux) and UEFI (systemd-boot) booting
author="ChatGPT"
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
# Use squashfs with zstd compression for faster boot
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-b' '1M' '-Xcompression-level' '19')
# Ensure important files have correct permissions
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.bash_profile"]="0:0:755"
  ["/root/.zprofile"]="0:0:755"
  ["/usr/local/bin/drive-info.sh"]="0:0:755"
)
