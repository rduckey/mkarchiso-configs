# Define build parameters
profile_name='Arch Recovery ISO'
iso_title='Arch Recovery Environment'
iso_label='ARCH_RECOVERY'
iso_publisher='rubberduckey'
iso_application='Comprehensive Arch-based Recovery ISO'
install_dir='arch'
bootmodes=('uefi-x64.systemd-boot.esp')

arch='x86_64'
pacman_conf='pacman.conf'
airootfs_image_type='squashfs'
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19')

file_permissions=(
  ["/etc/motd"]="0:0:644"
  ["/home/liveuser/scripts"]="0:0:755"
)

file_permissions+=(
  ["/etc/xdg/autostart/recovery-toolkit.desktop"]="0:0:644"
)
