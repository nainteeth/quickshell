import QtQuick
import Quickshell.Widgets
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import ".."
import "../components"

PanelWindow {
    id: launcherWindow
    implicitWidth: launcherPill.width
    implicitHeight: searchPill.height + 8 + 400 + launcherPill.topPadding + launcherPill.bottomPadding
    color: "transparent"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
    property var appList: []
    property var searchedApps: {
        if (!searchField.text) {
            return appList;
        }
        let query = searchField.text.toLowerCase();
        return appList.filter(app => app.name.toLowerCase().includes(query));
    }
    HyprlandFocusGrab {
        active: true
        windows: [launcherWindow]
        onCleared: {
            GlobalState.launcherOpen = false;
        }
    }
    MouseArea {
        anchors.top: launcherPill.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onClicked: {
            GlobalState.launcherOpen = false;
        }
    }

    // this grabs all the apps and puts them in an array
    Process {
        id: appListProcess
        running: true
        command: ["python3", "/home/nainteeth/.config/quickshell/scripts/list-apps.py"]
        stdout: StdioCollector {
            onStreamFinished: {
                appList = JSON.parse(text);
            }
        }
    }
    function launchApp(execString) {
        // Welcome to the most cursed function ever.
        // Desktop entrys have weird exec strings
        let cleaned = execString.replace(/%[fFuUick%]/g, "").trim();
        let parts = cleaned.split(" ").filter(p => p.length > 0);

        Quickshell.execDetached({
            command: parts
        });
    }
    Pill {
        id: launcherPill
        clickable: false
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        Column {
            spacing: 8

            Row {
                spacing: 4
                Pill {
                    id: searchPill
                    implicitWidth: 200
                    TextField {
                        id: searchField
                        anchors.fill: parent
                        placeholderText: "Search apps..."
                        color: Theme.textColor
                        placeholderTextColor: Theme.textColor
                        verticalAlignment: TextInput.AlignVCenter

                        // this removes the default background of the text field, so it looks like a pill
                        background: Item {}

                        focus: true
                        onVisibleChanged: if (visible)
                            forceActiveFocus()

                        onAccepted: {
                            if (searchedApps.length > 0) {
                                launchApp(searchedApps[0].exec);
                                GlobalState.launcherOpen = false;
                            }
                        }
                        Keys.onEscapePressed: {
                            GlobalState.launcherOpen = false;
                        }
                    }
                }
                Pill {
                    id: reloadPill
                    implicitHeight: searchPill.height
                    Text {
                        text: "󰑓"
                        color: Theme.textColor
                        font.pixelSize: 14
                    }

                    onClicked: {
                        appListProcess.running = true;
                    }
                }
            }

            Pill {
                id: resultsPill
                visible: implicitHeight > 0
                clickable: false
                border.width: 0
                implicitWidth: searchPill.width + reloadPill.width + 4
                // the math min caps the height of the results pill to 400, so it doesn't get too big
                // it also hides the pill if the text field is empty
                implicitHeight: searchField.text.trim().length > 0 ? Math.min(appListView.contentHeight, 400) : 0

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutCubic
                    }
                }

                ListView {
                    id: appListView
                    anchors.fill: parent
                    clip: true
                    model: searchedApps
                    spacing: 4

                    delegate: Pill {
                        width: appListView.width
                        onClicked: {
                            launchApp(modelData.exec);
                            GlobalState.launcherOpen = false;
                        }
                        RowLayout {
                            spacing: 8
                            IconImage {
                                source: Quickshell.iconPath(modelData.icon, true)
                                implicitSize: 24
                            }
                            Text {
                                text: modelData.name
                                color: Theme.textColor

                                width: parent.width
                                wrapMode: Text.WordWrap
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
