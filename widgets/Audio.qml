pragma ComponentBehavior: Bound
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
    id: root

    readonly property int volumePercentage: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100)

    function volumeIcon() {
        if (volumePercentage === 0)
            return "󰖁";
        if (volumePercentage < 50)
            return "󰕿";
        if (volumePercentage < 80)
            return "󰖀";
        return "󰕾";
    }

    collapsedContent: Row {
        spacing: 6

        Text {
            id: audioText
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: root.volumePercentage + "%"
        }

        // Selects the appropriate icon based on the current volume level.
        Text {
            id: audioIcon
            color: Theme.textColor
            font.pixelSize: 14
            font.bold: true
            text: root.volumeIcon()
        }
    }

    // Expanded view with volume control and a button to open pavucontrol.
    // Outsourcing work! Yippie!
    expandedContent: Column {
        spacing: 6

        Text {
            color: Theme.textColor
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Global Volume: " + root.volumePercentage + "%"
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
