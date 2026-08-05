import QtQuick
import ".."
import "../components"

ExpandablePill {
    id: clockPill
    widgetName: "clock"

    expandedHeight: 80
    expandedWidth: 220
    collapsedWidth: clockText.width + 24

    Column {
        width: clockPill.isExpanded ? (clockPill.width - 24) : implicitWidth
        height: clockPill.isExpanded ? (clockPill.height - 16) : implicitHeight
        spacing: 6

        // Unexpanded state
        Text {
            id: clockText
            visible: !clockPill.isExpanded // Hides this text when the widget opens
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: new Date().toLocaleString(Theme.locale, "ddd d MMM hh:mm")
        }

        // Expanded state
        Text {
            visible: clockPill.isExpanded
            color: Theme.textColor
            font.pixelSize: 14
            // TODO: Add a calender
        }
    }

    // Updates the clock
    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = new Date().toLocaleString(Theme.locale, "ddd d MMM hh:mm")
    }
}
