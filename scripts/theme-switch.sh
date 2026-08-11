#!/usr/bin/env bash
# Usage: theme-switch.sh [dark|light|catppuccin-latte|catppuccin-frappe|catppuccin-macchiato|catppuccin-mocha]
# This script only switches the gtk theme and sets the color scheme to be either light or dark. This is what some applications use to determine whether to use a light or dark theme, including Discord sometimes. I have not yet figured out if it is dependent on the current moon phase or what. Discord is just being Discord. Please contact me if you for some reason read this AND figure out a solution. Thanks.

set -euo pipefail

THEME="${1:-}"

case "$THEME" in
    light)
        COLOR_SCHEME="prefer-light"
        GTK_THEME="Adwaita"
        ;;
    dark)
        COLOR_SCHEME="prefer-dark"
        GTK_THEME="Adwaita-dark"
        ;;
    catppuccin-latte)
        COLOR_SCHEME="prefer-light"
        GTK_THEME="catppuccin-latte-blue-standard+default"
        ;;
    catppuccin-frappe)
        COLOR_SCHEME="prefer-dark"
        GTK_THEME="catppuccin-frappe-blue-standard+default"
        ;;
    catppuccin-macchiato)
        COLOR_SCHEME="prefer-dark"
        GTK_THEME="catppuccin-macchiato-blue-standard+default"
        ;;
    catppuccin-mocha)
        COLOR_SCHEME="prefer-dark"
        GTK_THEME="catppuccin-mocha-blue-standard+default"
        ;;
    *)
        exit 1
        ;;
esac

gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

// This refreshes the ghostty theme
pkill -SIGUSR2 ghostty || true

echo "Theme switched to: $THEME"
