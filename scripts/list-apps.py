#!/usr/bin/env python3
# WARNING: THIS SCRIPT IS VIBECODED. I REFUSE TO LEARN PYTHON FOR A SINGLE SCRIPT. THANKS. But i did read it. Its not that complex.
import configparser
import json
import os

APP_DIRS = [
    "/usr/share/applications",
    os.path.expanduser("~/.local/share/applications"),
    "/var/lib/flatpak/exports/share/applications",
    os.path.expanduser("~/.local/share/flatpak/exports/share/applications"),
]

apps = []

for directory in APP_DIRS:
    if not os.path.isdir(directory):
        continue
    for filename in os.listdir(directory):
        if not filename.endswith(".desktop"):
            continue

        desktop_file = os.path.join(directory, filename)

        parser = configparser.ConfigParser(interpolation=None)
        try:
            parser.read(desktop_file, encoding="utf-8")
        except configparser.Error:
            continue

        if "Desktop Entry" not in parser:
            continue

        entry = parser["Desktop Entry"]

        if entry.get("NoDisplay", "false").lower() == "true":
            continue
        if entry.get("Type", "Application") != "Application":
            continue

        name = entry.get("Name")
        if not name:
            continue

        apps.append(
            {
                "name": name,
                "desktopFile": desktop_file,
                "icon": entry.get("Icon", ""),
            }
        )

print(json.dumps(apps))
