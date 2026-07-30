import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

ShellRoot {
        PanelWindow {
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

                // Left side (empty for now, add stuff later)
                Item { Layout.fillWidth: true }

                // Clock, centered-ish by the fillWidth items on both sides
                Text {
                    id: clockText
                    color: "#ffffff" // text color, change me
                    font.pixelSize: 14
                    font.bold: true
                    text: Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm")
                }

                Item { Layout.fillWidth: true }
            }

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd d MMM  hh:mm")
            }
        }
}
