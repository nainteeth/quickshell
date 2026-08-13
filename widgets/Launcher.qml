// This allows you to use IDs from outer components in nested components
pragma ComponentBehavior: Bound

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

    // Store all installed apps in an array
    property var allApps: []

    // This gives the path to the list-apps.py script, which is used to get the list of installed apps
    readonly property string appListScriptPath: Qt.resolvedUrl("../scripts/list-apps.py").toString().replace("file://", "")

    // This filters the appList based on the search. It also checks the launch count of the apps and sorts them by that, so the most used apps are at the top.
    property var sortedSearchResults: { // This is one of the more complex things in this shell. Which is why there are a lot of comments

        // This takes the current search and makes it all lower case and removes any spaces at the start or the end.
        let query = searchField.text.toLowerCase().trim();

        // If the search is empty, return all apps
        if (!query)
            return allApps;

        // This filters the list of all apps to only include those that start with the search query. It also makes the search case insensitive by converting both the app name and the query to lower case.
        let unsortedSearchResults = allApps.filter(app => app.name.toLowerCase().startsWith(query));

        // Then this filtered list is sorted by the launch count of the apps.
        // The sort function does quite a bit in the background which is why you don't need to manually go over the list. Just explain how things should be compared by using a and b and everything else is handled by the sort function.
        unsortedSearchResults.sort((a, b) => {
            // This gets the launch count of the two apps being compared
            // You can check LauncherState.qml to see how the launch count is stored and retrieved. In short, it uses a JSON object in the settings.conf file to keep track of how many times each app has been launched.
            let aCount = LauncherState.getLaunchCount(a.desktopFile);
            let bCount = LauncherState.getLaunchCount(b.desktopFile);

            // If the launch counts are different, sort by launch count (descending). This works because of how the sort works. If the result is negative, a is sorted before b. If the result is positive, b is sorted before a. If the result is 0, the order of a and b is unchanged.
            if (aCount !== bCount)
                return bCount - aCount;

            // If the launch counts are the same, sort by name (ascending)
            return a.name.localeCompare(b.name);
        });

        return unsortedSearchResults;
    }

    // This grabs focus.
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
        command: ["python3", launcherWindow.appListScriptPath]
        stdout: StdioCollector {
            onStreamFinished: {
                launcherWindow.allApps = JSON.parse(text);
            }
        }
    }

    // this is a function to launch the given app
    function launchApp(desktopFile) {
        LauncherState.incrementLaunchCount(desktopFile);

        Quickshell.execDetached({
            command: ["gio", "launch", desktopFile]
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

                        // this is the function that is called when the user presses enter in the search field
                        onAccepted: {
                            if (launcherWindow.sortedSearchResults.length > 0) {
                                launcherWindow.launchApp(launcherWindow.sortedSearchResults[0].desktopFile);
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
                        duration: 200
                        easing.type: Easing.OutCubic
                    }
                }

                ListView { // This lists the apps that match the search query
                    id: appListView
                    anchors.fill: parent
                    clip: true
                    model: launcherWindow.sortedSearchResults
                    spacing: 4

                    delegate: Pill {
                        id: appPill
                        required property var modelData
                        width: appListView.width
                        onClicked: {
                            launcherWindow.launchApp(appPill.modelData.desktopFile);
                            GlobalState.launcherOpen = false;
                        }
                        RowLayout {
                            spacing: 8
                            IconImage {
                                source: Quickshell.iconPath(appPill.modelData.icon, true)
                                implicitSize: 24
                            }
                            Text {
                                text: appPill.modelData.name
                                color: Theme.textColor

                                wrapMode: Text.WordWrap

                                // idk why these work. Doesn't make sense in my head. But im too lazy to figure it out rn.
                                Layout.alignment: Qt.AlignVCenter
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
}
