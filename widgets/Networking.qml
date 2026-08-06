import QtQuick
import Quickshell.Io

import ".."
import "../components"

ExpandablePill {
    id: networkPill
    widgetName: "network"
    expandedHeight: 600
    expandedWidth: 220
    collapsedWidth: networkRow.width + 24

    property var activeNetworkSSID
    property int activeNetworkSignalStrength

    Column {
        width: networkPill.isExpanded ? (networkPill.width - 24) : implicitWidth
        height: networkPill.isExpanded ? (networkPill.height - 16) : implicitHeight
        spacing: 6

        // Unexpanded state
        Row {
            id: networkRow
            spacing: 6
            Text {
                id: currentNetworkSignalStrength
                visible: !networkPill.isExpanded
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
                visible: !networkPill.isExpanded
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: networkPill.activeNetworkSSID
            }
        }

        // Expanded state
        Text {
            id: expNetworkText
            visible: networkPill.isExpanded
            color: Theme.textColor
            font.pixelSize: 14
        }

        Process {
            id: networkProcess
            running: true
            command: ["env", "LC_ALL=C", "nmcli", "-t", "-f", "active,ssid,signal", "dev", "wifi", "list"]
            stdout: StdioCollector {
                onStreamFinished: {
                    let lines = text.split("\n");
                    let activeLine = lines.find(line => line.startsWith("yes:"));
                    let parts = activeLine.split(":");
                    // parts[0] = "yes", parts[1] = SSID, parts[2] = signal
                    networkPill.activeNetworkSSID = parts[1];
                    networkPill.activeNetworkSignalStrength = parseInt(parts[2]);
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
