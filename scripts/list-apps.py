#!/usr/bin/env python3
# WARNING: THIS SCRIPT IS VIBECODED. I REFUSE TO LEARN PYTHON FOR A SINGLE SCRIPT. THANKS.
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

        parser = configparser.ConfigParser(interpolation=None)
        try:
            parser.read(os.path.join(directory, filename), encoding="utf-8")
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
        exec_cmd = entry.get("Exec")
        if not name or not exec_cmd:
            continue

        apps.append(
            {
                "name": name,
                "exec": exec_cmd,
                "icon": entry.get("Icon", ""),
            }
        )

print(json.dumps(apps))
