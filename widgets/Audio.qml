import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."
import "../components"

ExpandablePill {
    id: audioPill
    widgetName: "audio"

    Item {
        implicitWidth: audioPill.isExpanded ? expandedView.implicitWidth : collapsedView.implicitWidth
        implicitHeight: audioPill.isExpanded ? expandedView.implicitHeight : collapsedView.implicitHeight

        // unexpanded state
        Row {
            id: collapsedView
            visible: !audioPill.isExpanded
            anchors.centerIn: parent
            spacing: 6

            Text {
                id: audioText
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"
            }
            Text {
                id: audioIcon
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

        // expanded state
        Column {
            id: expandedView
            visible: audioPill.isExpanded
            anchors.centerIn: parent
            spacing: 6

            Text {
                color: Theme.textColor
                font.pixelSize: 14
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Global Volume: " + Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"
            }

            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink]
            }

            Slider {
                id: volumeSlider
                anchors.horizontalCenter: parent.horizontalCenter
                implicitWidth: 150
                from: 0
                to: 100
                stepSize: 1
                value: (Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100
                onMoved: {
                    Pipewire.defaultAudioSink.audio.volume = value / 100;
                }
            }

            Pill {
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: pavuProcess.running = true

                Row {
                    spacing: 6
                    Text {
                        color: Theme.textColor
                        text: "Open Pavucontrol"
                        font.pixelSize: 14
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Process {
                        id: pavuProcess
                        command: ["pavucontrol"]
                    }
                }
            }
        }
    }
}
