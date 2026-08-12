pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import ".."
import "../components"

ExpandablePill {
    id: powerMenuPill

    collapsedContent: Text {
        id: powerIcon
        color: Theme.textColor
        font.pixelSize: 14
        font.bold: true
        text: {
            text: "󰐥";
        }
    }

    expandedContent: Column {
        spacing: 12

        Pill {
            id: poweroffPill
            onClicked: {
                poweroffProcess.running = true;
            }
            Row {
                Text {
                    color: Theme.textColor
                    text: "Shutdown"
                    font.pixelSize: 14
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
                Process {
                    id: poweroffProcess
                    command: ["systemctl", "poweroff"]
                }
            }
        }

        Pill {
            id: rebootPill
            onClicked: {
                rebootProcess.running = true;
            }
            Row {
                Text {
                    color: Theme.textColor
                    text: "Reboot"
                    font.pixelSize: 14
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
                Process {
                    id: rebootProcess
                    command: ["systemctl", "reboot"]
                }
            }
        }
    }
}
