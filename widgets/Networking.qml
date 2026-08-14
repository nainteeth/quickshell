pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io
import Quickshell.Networking as QSNet
import ".."
import "../components"

ExpandablePill {
    id: root
    visible: !root.ethernetConnected

    // The devices are things like your wifi card or your wired ethernet port
    readonly property var networkDevices: QSNet.Networking.devices.values
    readonly property var wifiDevice: root.networkDevices.find(device => device.type === QSNet.DeviceType.Wifi) ?? null
    readonly property var wiredDevice: root.networkDevices.find(device => device.type === QSNet.DeviceType.Wired) ?? null
    readonly property var activeWifiNetwork: root.wifiDevice ? root.wifiDevice.networks.values.find(network => network.connected) ?? null : null
    readonly property string activeNetworkSSID: root.activeWifiNetwork ? root.activeWifiNetwork.name : "Not connected"
    readonly property int activeNetworkSignalStrength: root.activeWifiNetwork ? Math.round(root.activeWifiNetwork.signalStrength * 100) : 0
    readonly property bool ethernetConnected: root.wiredDevice?.network?.connected ?? false
    readonly property var availableWifiNetworks: wifiDevice ? wifiDevice.networks.values : []

    function networkSignalIcon(signal) {
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

    collapsedContent: Row {
        spacing: 6

        Text {
            id: currentNetworkSignalStrength
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: root.networkSignalIcon(root.activeNetworkSignalStrength)
        }

        Text {
            id: unexpNetworkText
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: root.activeNetworkSSID
        }
    }

    expandedContent: Column {
        id: expContent
        spacing: 12

        Text {
            id: expNetworkText
            color: Theme.textColor
            font.pixelSize: 14
            text: "Connected to: " + root.activeNetworkSSID
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // TODO: Fix this
        ListView {
            id: wifiNetworks
            width: 200
            implicitHeight: contentHeight
            model: root.availableWifiNetworks

            delegate: Pill {
                id: wifiPill
                required property var modelData
                // color: {
                //     if (modelData.name.connected) {
                //         Theme.inactiveTextColor;
                //     }
                // }
                width: expContent.width
                onClicked: {
                    if (wifiPill.modelData.connected) {
                        wifiPill.modelData.disconnect();
                    } else {
                        wifiPill.modelData.connect();
                    }
                }
                Text {
                    text: wifiPill.modelData.name + "  " + root.networkSignalIcon(wifiPill.modelData.name.signalStrength * 100)
                    color: Theme.textColor
                }

                // Component.onCompleted: {
                //     wifiPill.modelData.connectionFailed();
                // }
            }
        }

        // NMTui Button:
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
            }
        }

        Process {
            id: nmtuiProcess
            command: ["ghostty", "-e", "nmtui"]
        }
    }
}
