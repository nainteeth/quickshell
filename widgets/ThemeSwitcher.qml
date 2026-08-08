import QtQuick
import Quickshell.Io
import ".."
import "../components"

Pill {
    id: themePill

    Row {
        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: Theme.isDark ? "Dark Theme" : "Light Theme"
            anchors.verticalCenter: parent.verticalCenter
        }

        Process {
            id: themeProcess
        }
    }

    onClicked: {
        Theme.isDark = !Theme.isDark;
        let mode = Theme.isDark ? "dark" : "light";

        let scriptUrl = Qt.resolvedUrl("../scripts/theme-switch.sh").toString();
        // the above line returns a file url,
        // so we need to remove the "file://" prefix to get the actual path
        let scriptPath = scriptUrl.replace("file://", "");

        themeProcess.command = ["bash", "-c", scriptPath + " " + mode];
        themeProcess.running = true;
    }
}
