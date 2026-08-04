import QtQuick
import Quickshell.Services.UPower
import QtQuick.Controls
import ".."
import "../components"

Pill {
    id: batteryPill
    visible: UPower.displayDevice.isLaptopBattery

    MouseArea {
        height: batteryContent.height
        width: batteryContent.width
        hoverEnabled: true
        ToolTip.visible: containsMouse ? true : false
        ToolTip.text: UPower.displayDevice.state == UPowerDeviceState.Discharging ? Math.round(UPower.displayDevice.timeToEmpty / 60) + " minutes left." : Math.round(UPower.displayDevice.timeToFull / 60) + " minutes left."

        Row {
            id: batteryContent
            anchors.centerIn: parent
            spacing: 6

            Text {
                id: batteryText
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: Math.round(UPower.displayDevice.percentage * 100) + "%"
            }
        }
    }
}
