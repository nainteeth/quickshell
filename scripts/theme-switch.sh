#!/usr/bin/env bash
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
    catppuccin-light)
        COLOR_SCHEME="prefer-light"
        GTK_THEME="Catppuccin-Light"
        ;;
    catppuccin-dark)
        COLOR_SCHEME="prefer-dark"
        GTK_THEME="Catppuccin-Dark"
        ;;
    adwaita-dark)
        COLOR_SCHEME="prefer-dark"
        GTK_THEME="Adwaita-dark"
        ;;
    compline-dark)
        COLOR_SCHEME="prefer-dark"
        GTK_THEME="Adwaita-dark"
        ;;
    lauds-light)
        COLOR_SCHEME="prefer-light"
        GTK_THEME="Adwaita"
        ;;
    *)
        exit 1
        ;;
esac

gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"


# This refreshes the ghostty theme
pkill -SIGUSR2 ghostty || true

# Reload hyprland config
# My hyprland config reads the contents of settings.conf for theming
hyprctl reload

echo "Theme switched to: $THEME"
