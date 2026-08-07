import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."
import "../components"

ExpandablePill {
    id: audioPill
    widgetName: "audio"

    expandedHeight: 100
    expandedWidth: 185
    collapsedWidth: audioRow.width + 24

    Column {
        width: audioPill.isExpanded ? (audioPill.width - 24) : implicitWidth
        height: audioPill.isExpanded ? (audioPill.height - 16) : implicitHeight
        spacing: 6

        // Unexpanded state
        Row {
            id: audioRow
            spacing: 6
            Text {
                id: audioText
                visible: !audioPill.isExpanded
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
            }
            Text {
                id: audioIcon
                visible: !audioPill.isExpanded
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: {
                    let volume = Pipewire.defaultAudioSink?.audio.volume ?? 0;

                    if (volume >= 0.80)
                        return "";
                    if (volume >= 0.60)
                        return "󰕾";
                    if (volume >= 0.40)
                        return "";
                    if (volume > 0)
                        return "󰖁";
                    return "?";
                }
            }
        }

        // Expanded state
        Column {
            visible: audioPill.isExpanded
            spacing: 6
            Text {
                color: Theme.textColor
                font.pixelSize: 14
                text: "Global Volume: " + Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
            }
            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink]
            }
            Slider {
                id: volumeSlider
                from: 0
                to: 100
                stepSize: 1
                value: (Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100
                onMoved: {
                    Pipewire.defaultAudioSink.audio.volume = value / 100;
                }
            }
            Pill {
                width: parent.width
                height: 30
                color: pavuMouseArea.containsMouse ? Theme.hoverBackgroundColor : "transparent"
                border.color: Theme.borderColor
                border.width: 1
                radius: 4

                Text {
                    anchors.centerIn: parent
                    color: Theme.textColor
                    text: "Open Pavucontrol"
                    font.pixelSize: 14
                    font.bold: true
                }

                MouseArea {
                    id: pavuMouseArea
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: pavuProcess.running = true
                }

                Process {
                    id: pavuProcess
                    command: ["pavucontrol"]
                }
            }
        }
    }
}
