#!/usr/bin/env bash
# Usage: theme-switch.sh [light|dark]
# Called from Quickshell with the target mode already decided.

set -euo pipefail

MODE="${1:-}"
if [[ "$MODE" != "light" && "$MODE" != "dark" ]]; then
    echo "Usage: $0 [light|dark]" >&2
    exit 1
fi

# GTK
if [[ "$MODE" == "dark" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
else
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
fi

# Ghostty
pkill -SIGUSR2 ghostty || true

echo "Theme switched to: $MODE"
