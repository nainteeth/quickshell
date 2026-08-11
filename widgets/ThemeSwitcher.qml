pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import ".."
import "../components"

ExpandablePill {
    id: themePill
    Layout.alignment: Qt.AlignTop

    readonly property var themeNames: ["dark", "light", "catppuccin-dark", "catppuccin-light"]

    collapsedContent: Row {
        spacing: 6

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: Theme.currentTheme.name
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            text: "▾"
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    expandedContent: Column {
        id: expandedThemeView
        spacing: 6

        function applyTheme(themeName) {
            Theme.setTheme(themeName);
            themeProcess.command = [themeScriptPath, themeName];
            themeProcess.running = true;
            GlobalState.expandedWidget = null;
        }

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            text: "Select Theme"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Repeater {
            model: themePill.themeNames

            delegate: Pill {
                id: themeOptionPill
                required property string modelData
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: expandedThemeView.applyTheme(themeOptionPill.modelData)

                Row {
                    spacing: 6

                    Text {
                        color: Theme.textColor
                        font.pixelSize: 14
                        font.bold: true
                        // tiny dot to show which theme is currently selected
                        text: Theme.themeName === themeOptionPill.modelData ? "• " + Theme.themes[themeOptionPill.modelData].name : Theme.themes[themeOptionPill.modelData].name
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        // This changes the relative path to an absolute path and removes the "file://" prefix
        readonly property string themeScriptPath: Qt.resolvedUrl("../scripts/theme-switch.sh").toString().replace("file://", "")

        Process {
            id: themeProcess
        }
    }
}
