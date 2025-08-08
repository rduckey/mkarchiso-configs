#!/usr/bin/env zsh
# Auto-start tasks on login at tty1
if [ -z "$DISPLAY" ] && [[ $(tty) == "/dev/tty1" ]]; then
    # Display system information using fastfetch
    if command -v fastfetch >/dev/null 2>&1; then
        fastfetch || true
    fi
    # Run custom drive info script
    if [ -x /usr/local/bin/drive-info.sh ]; then
        /usr/local/bin/drive-info.sh
    fi
    sleep 2
    if command -v startplasma-x11 >/dev/null 2>&1; then
        startplasma-x11 &
    fi
fi
