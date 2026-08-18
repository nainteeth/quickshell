import QtQuick
import Quickshell.Hyprland
import ".."
import "../components"

Pill {
    id: workspacesPill
    required property var screen
    hoverEnabled: false
    clickable: false

    function getWorkspaceIcon(workspace) {
        switch (workspace) {
            case 1:
                return "󱂈"
            case 2:
                return "󱂉"
            case 3:
                return "󱂊"
            case 4:
                return "󱂋"
            case 5:
                return "󱂌"
            case 6:
                return "󱂍"
            case 7:
                return "󱂎"
            case 8:
                return "󱂏"
            case 9:
                return "󱂐"
            case 10:
                return "󱂑"
            default:
                return "workspace"
        }
    }

    Row {
        id: workspacesRow
        spacing: 12

        Repeater {
            model: Hyprland.workspaces.values.filter(ws => ws.monitor == Hyprland.monitorFor(workspacesPill.screen) && ws.id > 0)

            Text {
                id: workspaceText
                required property var modelData
                font.family: "JetBrainsMono Nerd Font"
                color: modelData.active ? Theme.textColor : Theme.inactiveTextColor
                font.pixelSize: 14
                scale: 1.7 // This makes the icons larger without changing the pill sizing
                font.bold: true
                text: getWorkspaceIcon(modelData.id)


                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceText.modelData.id} })`);
                    }
                }
            }
        }
    }
}
