import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Services.Pipewire
import ".."
import "../components"

// Audio volume widget that expands to show a slider and settings shortcut.
// TODO: Add app specific sliders
// TODO: Add a selection of the input and output device
// TODO: Add a input device volume slider
ExpandablePill {
    id: audioPill
    widgetName: "audio"

    Item {
        // Resizes the widget based on its current state.
        implicitWidth: audioPill.isExpanded ? expandedView.implicitWidth : collapsedView.implicitWidth
        implicitHeight: audioPill.isExpanded ? expandedView.implicitHeight : collapsedView.implicitHeight

        // Collapsed view showing volume percentage and a dynamic icon.
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

            // Selects the appropriate icon based on the current volume level.
            Text {
                id: audioIcon
                color: Theme.textColor
                font.pixelSize: 14
                font.bold: true
                text: {
                    let volume = Pipewire.defaultAudioSink?.audio.volume ?? 0;
                    if (volume >= 0.80)
                        return "";
                    if (volume >= 0.40)
                        return "󰕾";
                    if (volume >= 0.01)
                        return "";
                    if (volume == 0)
                        return "󰖁";
                    return "Can't get volume";
                }
            }
        }

        // Expanded view with volume control and a button to open pavucontrol.
        // Outsourcing work! Yippie!
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

            // Forces UI updates when the Pipewire sink changes externally.
            PwObjectTracker {
                objects: [Pipewire.defaultAudioSink]
            }

            // Reads and writes volume to the default audio sink.
            // TODO: Make it prettier
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

            // Button to launch the external pavucontrol application.
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
