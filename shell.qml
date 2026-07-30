import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            // Makes sure that the PanelWindow is created on each screen once
            required property var modelData
            screen: modelData

            // Which screen edges this bar attaches to
            anchors {
                top: true
                left: true
                right: true
            }

            height: 32
            color: "#000000" // background color

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                // Left side
                Repeater {
                    model: 10
                    Text {
                        color: Hyprland.focusedWorkspace?.id == index + 1 ? "#ffffff" : "#888888"
                        font.pixelSize: 14
                        font.bold: true
                        text: index + 1
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
                    text: Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm")
                }

                // Right side
                Item { Layout.fillWidth: true }
            }

            // Updates the clock
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm")
            }
        }
    }
}
