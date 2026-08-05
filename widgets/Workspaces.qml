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
            model: Hyprland.workspaces.values.filter(ws => ws.monitor == Hyprland.monitorFor(screen))
            MouseArea {
                width: workspaceText.width
                height: workspaceText.height
                Text {
                    id: workspaceText
                    anchors.centerIn: parent
                    color: modelData.active ? Theme.textColor : Theme.inactiveTextColor
                    font.pixelSize: 14
                    font.bold: true
                    text: modelData.id
                }
                onClicked: {
                    Hyprland.dispatch(`hl.dsp.focus({ workspace = ${modelData.id} })`);
                }
            }
        }
    }
}
