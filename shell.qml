//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower

ShellRoot {
    QtObject {
        id: attributes
        property color barColor: "#000000"
        property color textColor: "#ffffff"

        // workspace text colors
        property color activeColor: "#ffffff"
        property color inactiveColor: "#888888"

        property int barHeight: 32
        property int trayIconSize: 22
        property int workspaceIconSize: 32

        property var locale: Qt.locale("de_DE")
    }
    Variants {
        model: Quickshell.screens
        PanelWindow {
            // Makes sure that the PanelWindow is created on each screen once
            required property var modelData
            screen: modelData

            id: panelWindow

            // Which screen edges this bar attaches to
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: attributes.barHeight
            color: attributes.barColor // background color

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                // Left side
                Repeater {
                    model: Hyprland.workspaces.values.filter(ws => ws.monitor == Hyprland.monitorFor(modelData))
                    MouseArea {
                        Layout.preferredHeight: attributes.workspaceIconSize
                        Layout.preferredWidth: attributes.workspaceIconSize
                        Text {
                            anchors.centerIn: parent
                            color: modelData.active ? "#ffffff" : "#888888"
                            font.pixelSize: 14
                            font.bold: true
                            text: modelData.id
                        }
                        onClicked: {
                            // this is a workaround for a bug in quickshell due to the new lua config
                            Hyprland.dispatch(`hl.dsp.focus({ workspace = ${modelData.id} })`);
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Middle side
                // Clock
                Text {
                    id: clockText
                    color: "#ffffff"
                    font.pixelSize: 14
                    font.bold: true
                    text: new Date().toLocaleString(attributes.locale, "ddd d MMM hh:mm")
                }

                // Right side
                Item { Layout.fillWidth: true }

                Repeater {
                    model: SystemTray.items
                    MouseArea {
                        Layout.preferredHeight: attributes.trayIconSize
                        Layout.preferredWidth: attributes.trayIconSize
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        Image {
                            source: modelData.icon
                            width: attributes.trayIconSize
                            height: attributes.trayIconSize
                            sourceSize.width: attributes.trayIconSize
                            sourceSize.height: attributes.trayIconSize
                        }
                        onClicked: {
                            if (mouse.button == Qt.LeftButton) {
                                modelData.activate()
                            } else if (mouse.button == Qt.RightButton) {
                                var pos = mapToItem(panelWindow.contentItem, mouse.x, mouse.y)
                                modelData.display(panelWindow, pos.x, pos.y)
                            }
                        }
                    }
                }
            }

            // Updates the clock
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clockText.text = new Date().toLocaleString(attributes.locale, "ddd d MMM hh:mm")
            }
        }
    }
}
