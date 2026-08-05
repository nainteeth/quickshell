import QtQuick
import Quickshell.Services.UPower
import ".."
import "../components"

ExpandablePill {
    id: batteryPill
    widgetName: "battery"
    visible: UPower.displayDevice.isLaptopBattery

    // Define the specific dimensions for the battery widget
    expandedHeight: 60
    expandedWidth: 100
    collapsedWidth: batteryContent.width + 12

    Column {
        width: batteryPill.isExpanded ? (batteryPill.width - 24) : implicitWidth
        height: batteryPill.isExpanded ? (batteryPill.height - 16) : implicitHeight

        Row {
            id: batteryContent
            spacing: 6
            Text {
                color: Theme.textColor
                font.pixelSize: 14
                font.family: "JetBrainsMono Nerd Font"
                text: {
                    let percent = UPower.displayDevice.percentage;

                    if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                        return "⚡";
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
            visible: batteryPill.isExpanded
            color: Theme.textColor
            text: UPower.displayDevice.state == UPowerDeviceState.Discharging ? Math.round(UPower.displayDevice.timeToEmpty / 60) + " min left" : Math.round(UPower.displayDevice.timeToFull / 60) + " min left"
        }
    }
}
