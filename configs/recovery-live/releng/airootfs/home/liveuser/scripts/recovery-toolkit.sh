#!/bin/bash
# Main GUI launcher using yad
exec yad --form --title "Arch Recovery Toolkit" \
  --field="Run CLI Toolkit":f './scripts/cli_tool_selector.sh' \
  --field="Launch Timeshift":f 'timeshift-launcher' \
  --field="Launch GParted":f 'gparted' \
  --field="Launch Clonezilla":f './scripts/clonezilla_launcher.sh' \
  --field="Browse Files":f 'thunar' \
  --field="System Monitor":f 'xfce4-taskmanager'