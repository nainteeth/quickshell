import QtQuick
import ".."
import "../components"

Pill {
    id: clockPill
    Text {
        id: clockText
        anchors.centerIn: parent
        color: Theme.textColor
        font.pixelSize: 14
        font.bold: true
        text: new Date().toLocaleString(Theme.locale, "ddd d MMM hh:mm")
    }

    // Updates the clock
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = new Date().toLocaleString(Theme.locale, "ddd d MMM hh:mm")
    }
}
