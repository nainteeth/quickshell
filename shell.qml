//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Services.UPower
import QtQuick.Controls

ShellRoot {
    QtObject {
        id: attributes
        property color barColor: "#000000"
        property color textColor: "#C0C0C0"

        // workspace text colors
        property color activeColor: "#C0C0C0"
        property color inactiveColor: "#888888"

        property int barHeight: 32
        property int trayIconSize: 22
        property int workspaceIconSize: 32
        property int batteryTextSize: 22

        property var locale: Qt.locale("de_DE")
    }
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panelWindow
            // Makes sure that the PanelWindow is created on each screen once
            required property var modelData
            screen: modelData

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
                Rectangle {
                    id: workspacesPill
                    color: "#C0C0C0"
                    height: 24
                    width: workspacesRow.width + 12
                    radius: 12
                    Row {
                        id: workspacesRow
                        spacing: 12
                        anchors.centerIn: parent
                        Repeater {
                            model: Hyprland.workspaces.values.filter(ws => ws.monitor == Hyprland.monitorFor(modelData))
                            MouseArea {
                                width: workspaceText.width
                                height: workspaceText.height
                                Text {
                                    id: workspaceText
                                    anchors.centerIn: parent
                                    color: modelData.active ? "#000000" : "#888888"
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

                Item {
                    Layout.fillWidth: true
                }

                // Middle side
                // Clock
                Rectangle {
                    id: clockPill
                    color: "#C0C0C0"
                    height: 24
                    width: clockText.width + 12
                    radius: 12
                    Text {
                        id: clockText
                        anchors.centerIn: parent
                        color: "#000000"
                        font.pixelSize: 14
                        font.bold: true
                        text: new Date().toLocaleString(attributes.locale, "ddd d MMM hh:mm")
                    }
                }

                // Right side
                Item {
                    Layout.fillWidth: true
                }

                MouseArea {
                    Layout.preferredHeight: batteryPill.height
                    Layout.preferredWidth: batteryPill.width
                    hoverEnabled: true
                    ToolTip.visible: containsMouse ? true : false
                    ToolTip.text: UPower.displayDevice.state == UPowerDeviceState.Discharging ? Math.round(UPower.displayDevice.timeToEmpty / 60) + " minutes left." : Math.round(UPower.displayDevice.timeToFull / 60) + " minutes left."

                    Rectangle {
                        id: batteryPill
                        color: "#C0C0C0"
                        height: 24
                        width: batteryContent.width + 12
                        radius: 12
                        Row {
                            id: batteryContent
                            anchors.centerIn: parent
                            spacing: 6

                            Text {
                                id: batteryText
                                color: "#000000"
                                font.pixelSize: 14
                                font.bold: true
                                text: Math.round(UPower.displayDevice.percentage * 100) + "%"
                            }
                        }
                    }
                }

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
                                modelData.activate();
                            } else if (mouse.button == Qt.RightButton) {
                                var pos = mapToItem(panelWindow.contentItem, mouse.x, mouse.y);
                                modelData.display(panelWindow, pos.x, pos.y);
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
