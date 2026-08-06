import QtQuick
import Quickshell.Io

import ".."
import "../components"

ExpandablePill {
    id: networkPill
    widgetName: "network"
    Component.onCompleted: console.log("network widget created")

    expandedHeight: 600
    expandedWidth: 220
    collapsedWidth: unexpNetworkText.width + 24

    Column {
        width: networkPill.isExpanded ? (networkPill.width - 24) : implicitWidth
        height: networkPill.isExpanded ? (networkPill.height - 16) : implicitHeight
        spacing: 6

        // Unexpanded state
        Row {
            Text {
                id: currentNetworkSignalStrength
                visible: !networkPill.isExpanded
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                // text: {
                //     let signal = ??; // how do i grab the signal strenght of the current network?

                //     if (signal >= ???)
                //         return "󰣺";
                //     if (signal >= ???)
                //         return "󰣸";
                //     if (signal >= ???)
                //         return "󰣶";
                //     if (signal >= ???)
                //         return "󰣴";
                //     if (network disabled = true) // something like that
                //         return "󰣼";
                //     return "󰣽";
                // }
            }
            Text {
                id: unexpNetworkText
                visible: !networkPill.isExpanded
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                // text: // the currently connected network should be displayed here aswell as its signal strength as an icon. Therefore i use a Row.
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
            command: ["nmcli", "-t", "-f", "active,ssid,signal", "dev", "wifi", "list"]
            stdout: StdioCollector {
                onStreamFinished: expNetworkText.text = text
            }
        }
    }
}
