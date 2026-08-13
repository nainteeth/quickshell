pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import ".."
import "../components"

ExpandablePill {
    id: batteryPill
    visible: UPower.displayDevice.isLaptopBattery
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

    property var batteryPercentage: Math.round(UPower.displayDevice.percentage * 100) + "%"

    function batteryIcon(percent) {
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

    function timeLeftText() {
        if (UPower.displayDevice.state == UPowerDeviceState.Discharging) {
            return Math.round(UPower.displayDevice.timeToEmpty / 60) + " min left";
        } else {
            return Math.round(UPower.displayDevice.timeToFull / 60) + " min left";
        }
    }

    collapsedContent: Row {
        spacing: 6

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font"
            text: batteryIcon(UPower.displayDevice.percentage)
        }

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: batteryPercentage
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
                text: batteryIcon(UPower.displayDevice.percentage)
            }

            Text {
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: batteryPercentage
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.textColor
            text: timeLeftText()
        }
    }
}
