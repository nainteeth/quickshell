//@ pragma UseQApplication
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import "./widgets"

ShellRoot {

    // IPC Handler to call a quickshell function with a hyprland keybind
    // In Hyprland config use:
    // hl.bind("SUPER + space", hl.dsp.exec_cmd("qs ipc call launcher toggle"))
    IpcHandler {
        target: "launcher"
        function toggle(): void {
            GlobalState.launcherOpen = !GlobalState.launcherOpen;
        }
    }

    // LazyLoader to only load the Launcher when its open (to save ressources)
    LazyLoader {
        active: GlobalState.launcherOpen
        Launcher {}
    }

    // Create a PanelWindow (bar) per monitor
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: panelWindow

            // Makes sure that the PanelWindow is created on each screen once
            // Without this the PanelWindow would appear multiple times on only one screen
            // For example: If you have 2 monitors, the PanelWindow would appear two times on one monitor
            // and not on the other at all.
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
            // TODO: Add a variable for the above hardcoded margin
            color: "transparent" // background color

            // Define the clickable area of the window
            // This is needed because the implicitHeight of the bar is larger than the actual bar
            // Without this you wouldn't be able to click on any applications that reside below the implicitHeight
            // If the implicitHeight of the bar is larger than the actual bar you can extend widgets within
            // the implicitHeight. Otherwise they would be cut off.
            mask: Region {
                item: barRow
            }

            // Invisible background overlay that activates only when a widget is expanded. Clicking anywhere on this empty space will close the currently expanded widget. z: -1 pushes it to the very bottom of the visual stack, ensuring that if you click on the widget itself, the widget intercepts the click first.
            MouseArea {
                anchors.fill: parent
                visible: GlobalState.expandedWidget !== null
                onClicked: GlobalState.expandedWidget = null
                z: -1  // magic
            }

            // Add the notification widget
            Notification {}

            Item { // This is the actual bar
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

                        // These lines make sure that the widget
                        // doesn't move if you expand another widget in the same RowLayout
                        // Try commenting it and click the audio widget
                        Layout.alignment: Qt.AlignTop
                    }

                    Audio {
                        Layout.alignment: Qt.AlignTop
                    }

                    Media {
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

                        // We need to pass the panelWindow
                        // so the context menu (right clicking a tray item) can be alligned
                        panelWindow: panelWindow
                    }
                    PowerMenu {
                        Layout.alignment: Qt.AlignTop
                    }
                }
            }
        }
    }
}
