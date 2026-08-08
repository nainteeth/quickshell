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

            implicitHeight: 1000 // height reserved for widgets
            exclusiveZone: Theme.barHeight + 8 // height for the actual bar. 8 is the top margin of the bar
            color: "transparent" // background color
            mask: Region {
                item: barRow
            }

            MouseArea {
                anchors.fill: parent
                visible: GlobalState.expandedWidget != ""
                onClicked: GlobalState.expandedWidget = ""
                z: -1  // magic
            }

            Item {
                id: barRow
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                anchors.topMargin: 8
                height: childrenRect.height

                // Left side
                RowLayout {
                    anchors.left: parent.left
                    anchors.top: parent.top

                    Workspaces {
                        screen: modelData
                        Layout.alignment: Qt.AlignTop
                    }

                    Audio {
                        Layout.alignment: Qt.AlignTop
                    }
                }

                // Middle side
                RowLayout {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top

                    Clock {
                        Layout.alignment: Qt.AlignTop
                    }
                }

                // Right side
                RowLayout {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    ThemeSwitcher {
                        Layout.alignment: Qt.AlignTop
                    }
                    Networking {
                        Layout.alignment: Qt.AlignTop
                    }

                    Battery {
                        Layout.alignment: Qt.AlignTop
                    }

                    Tray {
                        Layout.alignment: Qt.AlignTop
                        panelWindow: panelWindow
                    }
                }
            }
        }
    }
}
