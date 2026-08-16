pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Services.SystemTray
import ".."
import "../components"

Pill {
    id: trayPill
    visible: trayRepeater.count > 0
    required property var panelWindow
    Row {
        spacing: 6
        Repeater {
            id: trayRepeater
            model: SystemTray.items
            MouseArea {
                id: trayIconMouseArea
                required property var modelData
                width: Theme.trayIconSize
                height: Theme.trayIconSize
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                Image {
                    source: trayIconMouseArea.modelData.icon
                    width: Theme.trayIconSize
                    height: Theme.trayIconSize
                    sourceSize.width: Theme.trayIconSize
                    sourceSize.height: Theme.trayIconSize
                }
                onClicked: function (mouse) {
                    if (mouse.button == Qt.LeftButton) {
                        modelData.activate();
                    } else if (mouse.button == Qt.RightButton) {
                        let pos = trayIconMouseArea.mapToItem(trayPill.panelWindow.contentItem, mouse.x, mouse.y);
                        trayIconMouseArea.modelData.display(trayPill.panelWindow, pos.x, pos.y);
                    }
                }
            }
        }
    }
}
