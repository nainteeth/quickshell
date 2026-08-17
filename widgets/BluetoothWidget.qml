// TODO: Test this widget with an actual bluetooth device.
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Bluetooth
import Quickshell.Io
import ".."
import "../components"

ExpandablePill {
    id: bluetoothPill
    visible: Bluetooth.defaultAdapter !== null

    readonly property var adapter: Bluetooth.defaultAdapter
    // This filters the connected devices from the devices list
    readonly property var connectedDevices: Bluetooth.devices.values.filter(device => device.connected)

    collapsedItem: Row {
        spacing: 6

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: ""
        }

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: {
                if (!bluetoothPill.adapter?.enabled)
                    return "Off";
                if (bluetoothPill.connectedDevices.length === 1)
                    return bluetoothPill.connectedDevices[0].name;
                if (bluetoothPill.connectedDevices.length > 1)
                    return bluetoothPill.connectedDevices.length + " devices";
                return "On";
            }
        }
    }

    expandedItem: Column {
        id: expandedBluetoothView
        spacing: 12

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            anchors.horizontalCenter: expandedBluetoothView.horizontalCenter
            text: bluetoothPill.adapter?.enabled ? "Bluetooth is enabled" : "Bluetooth is disabled"
        }

        Pill {
            anchors.horizontalCenter: expandedBluetoothView.horizontalCenter
            onClicked: {
                if (bluetoothPill.adapter)
                    bluetoothPill.adapter.enabled = !bluetoothPill.adapter.enabled;
            }

            Row {
                spacing: 6

                Text {
                    color: Theme.textColor
                    text: bluetoothPill.adapter?.enabled ? "Turn Bluetooth Off" : "Turn Bluetooth On"
                    font.pixelSize: 14
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Pill {
            anchors.horizontalCenter: expandedBluetoothView.horizontalCenter
            onClicked: {
                                bluetoothSettingsProcess.running = true;
            }

            Row {
                spacing: 6

                Text {
                    color: Theme.textColor
                    text: "Open Blueman"
                    font.pixelSize: 14
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Process {
                    id: bluetoothSettingsProcess
                    command: ["bash", "-lc", "blueman-manager"]
                }
            }
        }

        Column {
            id: connectedDevicesColumn
            anchors.horizontalCenter: expandedBluetoothView.horizontalCenter
            spacing: 6

            Text {
                color: Theme.textColor
                font.pixelSize: 14
                text: "Connected devices"
                anchors.horizontalCenter: connectedDevicesColumn.horizontalCenter
            }

            Text {
                visible: bluetoothPill.connectedDevices.length === 0
                color: Theme.textColor
                font.pixelSize: 14
                text: "None"
                anchors.horizontalCenter: connectedDevicesColumn.horizontalCenter
            }

            Repeater {
                model: bluetoothPill.connectedDevices

                Text {
                    id: connectedDeviceText
                    required property var modelData
                    color: Theme.textColor
                    font.pixelSize: 14
                    text: {
                        if (connectedDeviceText.modelData.batteryAvailable)
                            return connectedDeviceText.modelData.name + " (" + Math.round(connectedDeviceText.modelData.battery * 100) + "%)";
                        return connectedDeviceText.modelData.name;
                    }
                    anchors.horizontalCenter: connectedDevicesColumn.horizontalCenter
                }
            }
        }
    }
}
