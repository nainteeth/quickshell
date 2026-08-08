import QtQuick
import Quickshell.Io
import ".."
import "../components"

ExpandablePill {
    id: networkPill
    widgetName: "network"

    property var activeNetworkSSID
    property int activeNetworkSignalStrength

    Item {
        implicitWidth: networkPill.isExpanded ? expandedView.implicitWidth : collapsedView.implicitWidth
        implicitHeight: networkPill.isExpanded ? expandedView.implicitHeight : collapsedView.implicitHeight

        Row {
            id: collapsedView
            visible: !networkPill.isExpanded
            anchors.centerIn: parent
            spacing: 6

            Text {
                id: currentNetworkSignalStrength
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: {
                    let signal = networkPill.activeNetworkSignalStrength;
                    if (signal >= 80)
                        return "󰣺";
                    if (signal >= 60)
                        return "󰣸";
                    if (signal >= 40)
                        return "󰣶";
                    if (signal >= 20)
                        return "󰣴";
                    return "󰣽";
                }
            }

            Text {
                id: unexpNetworkText
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: networkPill.activeNetworkSSID
            }
        }

        Column {
            id: expandedView
            visible: networkPill.isExpanded
            anchors.centerIn: parent
            spacing: 12

            Text {
                id: expNetworkText
                color: Theme.textColor
                font.pixelSize: 14
                text: "Connected to: " + networkPill.activeNetworkSSID
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Pill {
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: nmtuiProcess.running = true

                Row {
                    spacing: 6

                    Text {
                        color: Theme.textColor
                        text: "Open nmtui"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Process {
                        id: nmtuiProcess
                        command: ["ghostty", "-e", "nmtui"]
                    }
                }
            }
        }

        Process {
            id: networkProcess
            running: true
            command: ["env", "LC_ALL=C", "nmcli", "-t", "-f", "active,ssid,signal", "dev", "wifi", "list"]
            stdout: StdioCollector {
                onStreamFinished: {
                    let lines = text.split("\n");
                    let activeLine = lines.find(line => line.startsWith("yes:"));
                    if (activeLine) {
                        let parts = activeLine.split(":");
                        networkPill.activeNetworkSSID = parts[1];
                        networkPill.activeNetworkSignalStrength = parseInt(parts[2]);
                    }
                }
            }
        }

        Timer {
            interval: 5000
            running: true
            repeat: true
            onTriggered: networkProcess.running = true
        }
    }
}
