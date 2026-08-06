import QtQuick
import ".."
import "../components"

ExpandablePill {
    id: audioPill
    widgetName: "audio"

    expandedHeight: 80
    expandedWidth: 220
    collapsedWidth: audioText.width + 24

    Column {
        width: audioPill.isExpanded ? (audioPill.width - 24) : implicitWidth
        height: audioPill.isExpanded ? (audioPill.height - 16) : implicitHeight
        spacing: 6

        // Unexpanded state
        Text {
            id: audioText
            visible: !audioPill.isExpanded
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: "WIP: Audio"
        }

        // Expanded state
        Text {
            visible: audioPill.isExpanded
            color: Theme.textColor
            font.pixelSize: 14
        }
    }
}
