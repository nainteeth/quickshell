import QtQuick
import QtQuick.Layouts
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
                width: Theme.trayIconSize
                height: Theme.trayIconSize
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                Image {
                    source: modelData.icon
                    width: Theme.trayIconSize
                    height: Theme.trayIconSize
                    sourceSize.width: Theme.trayIconSize
                    sourceSize.height: Theme.trayIconSize
                }
                onClicked: {
                    if (mouse.button == Qt.LeftButton) {
                        modelData.activate();
                    } else if (mouse.button == Qt.RightButton) {
                        var pos = mapToItem(panelWindow.contentItem, mouse.x, mouse.y);
                        modelData.display(panelWindow, pos.x, pos.y);
                    }
                }
            }
        }
    }
}
