//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell

import "./widgets"

ShellRoot {
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

            implicitHeight: Theme.barHeight
            color: Theme.barColor // background color

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                // Left side
                Workspaces {
                    screen: modelData
                }

                Item {
                    Layout.fillWidth: true
                }

                // Middle side
                Clock {}

                Item {
                    Layout.fillWidth: true
                }

                // Right side
                Battery {}
                Tray {}
            }
        }
    }
}
