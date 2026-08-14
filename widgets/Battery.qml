pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import ".."
import "../components"

ExpandablePill {
    id: root
    visible: UPower.displayDevice.isLaptopBattery
    Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

    readonly property int batteryPercentage: Math.round(UPower.displayDevice.percentage * 100)

    function batteryIcon() {
        if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
            return "󱐋";
        }
        if (batteryPercentage >= 90)
            return "󰁹";
        if (batteryPercentage >= 80)
            return "󰂂";
        if (batteryPercentage >= 60)
            return "󰁿";
        if (batteryPercentage >= 40)
            return "󰁽";
        if (batteryPercentage >= 20)
            return "󰁻";
        if (batteryPercentage >= 10)
            return "󰁺";
        return "󰂎";
    }

    function timeLeftText() {
        if (batteryPercentage == 100) {
            return "Fully charged";
        } else if (UPower.displayDevice.state == UPowerDeviceState.Discharging) {
            return "Discharging: " + Math.round(UPower.displayDevice.timeToEmpty / 60) + " min left";
        } else {
            return "Charging: " + Math.round(UPower.displayDevice.timeToFull / 60) + " min left";
        }
    }

    collapsedContent: Row {
        spacing: 6

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.family: "JetBrainsMono Nerd Font"
            text: root.batteryIcon(UPower.displayDevice.percentage)
        }

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: root.batteryPercentage + "%"
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
                text: root.batteryIcon(UPower.displayDevice.percentage)
            }

            Text {
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: root.batteryPercentage + "%"
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.textColor
            text: root.timeLeftText()
        }
    }
}
