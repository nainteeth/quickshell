import QtQuick
import Quickshell.Io
import ".."
import "../components"

Pill {
    id: clockPill
    Row {
        MouseArea {
            width: clockText.width
            height: clockText.height

            Text {
                id: clockText
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: new Date().toLocaleString(Theme.locale, "ddd d MMM hh:mm")
            }

            onClicked: {
                Qt.openUrlExternally("https://calendar.google.com/calendar");
                hyprctlProcess.running = true;
            }
        }

        // Updates the clock
        Timer {
            id: clockTimer
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = new Date().toLocaleString(Theme.locale, "ddd d MMM hh:mm")
        }
        Process {
            id: hyprctlProcess
            // You shall not ask how this vibecoded line works.
            // It just focuses your default browser when opening the link.
            // If you want to open the url with another browser: No, you can't. This is a feature, not a bug.
            command: ["bash", "-c", "d=$(xdg-settings get default-web-browser); c=$(awk -F= '/^StartupWMClass/{print $2; exit}' /usr/share/applications/$d ~/.local/share/applications/$d 2>/dev/null); hyprctl dispatch \"hl.dsp.focus({ window = 'class:${c:-${d%.desktop}}' })\""]
        }
    }
}
