pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import ".."
import "../components"

ExpandablePill {
    id: batteryPill
    widgetName: "battery"
    visible: UPower.displayDevice.isLaptopBattery
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

    collapsedContent: Row {
        spacing: 6

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font"
            text: {
                let percent = UPower.displayDevice.percentage;

                if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                    return "󱐋";
                }
                if (percent >= 0.90)
                    return "󰁹";
                if (percent >= 0.80)
                    return "󰂂";
                if (percent >= 0.60)
                    return "󰁿";
                if (percent >= 0.40)
                    return "󰁽";
                if (percent >= 0.20)
                    return "󰁻";
                if (percent >= 0.10)
                    return "󰁺";
                return "󰂎";
            }
        }

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: Math.round(UPower.displayDevice.percentage * 100) + "%"
        }
    }

    expandedContent: Column {
        spacing: 6

        Row {
            spacing: 6
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                color: Theme.textColor
                font.pixelSize: 14
                font.family: "JetBrainsMono Nerd Font"
                text: {
                    let percent = UPower.displayDevice.percentage;

                    if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                        return "󱐋";
                    }
                    if (percent >= 0.90)
                        return "󰁹";
                    if (percent >= 0.80)
                        return "󰂂";
                    if (percent >= 0.60)
                        return "󰁿";
                    if (percent >= 0.40)
                        return "󰁽";
                    if (percent >= 0.20)
                        return "󰁻";
                    if (percent >= 0.10)
                        return "󰁺";
                    return "󰂎";
                }
            }

            Text {
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: Math.round(UPower.displayDevice.percentage * 100) + "%"
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.textColor
            text: UPower.displayDevice.state == UPowerDeviceState.Discharging ? Math.round(UPower.displayDevice.timeToEmpty / 60) + " min left" : Math.round(UPower.displayDevice.timeToFull / 60) + " min left"
        }
    }
}
