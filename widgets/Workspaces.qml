import QtQuick
import Quickshell.Hyprland
import ".."
import "../components"

Pill {
    id: workspacesPill
    required property var screen

    Row {
        id: workspacesRow
        spacing: 12

        Repeater {
            model: Hyprland.workspaces.values.filter(ws => ws.monitor == Hyprland.monitorFor(workspacesPill.screen) && ws.id > 0)

            Text {
                id: workspaceText
                required property var modelData
                color: modelData.active ? Theme.textColor : Theme.inactiveTextColor
                font.pixelSize: 14
                font.bold: true
                text: modelData.id

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
