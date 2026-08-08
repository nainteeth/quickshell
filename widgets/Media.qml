import QtQuick
import Quickshell.Services.Mpris
import ".."
import "../components"

Pill {
    id: mediaPill

    // This goes through the list of MPRIS players and returns the first one that is currently playing.
    // If none are playing, it returns the first player in the list, or null if there are no players.
    readonly property var activePlayer: {
        for (let i = 0; i < Mpris.players.length; i++) {
            if (Mpris.players[i].isPlaying)
                return Mpris.players[i];
        }
        return Mpris.players.length > 0 ? Mpris.players[0] : null;
    }

    // hides pill if there are no players available
    visible: activePlayer !== null

    Row {
        spacing: 12

        Text {
            id: prevIcon
            text: "󰒮"
            color: (mediaPill.activePlayer && mediaPill.activePlayer.canGoPrevious) ? Theme.textColor : Theme.inactiveTextColor
            font.pixelSize: 14

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mediaPill.activePlayer && mediaPill.activePlayer.canGoPrevious)
                        mediaPill.activePlayer.previous();
                }
            }
        }

        Text {
            id: playPauseIcon
            text: (mediaPill.activePlayer && mediaPill.activePlayer.isPlaying) ? "󰏤" : "󰐊"
            color: (mediaPill.activePlayer && mediaPill.activePlayer.canPause) ? Theme.textColor : Theme.inactiveTextColor
            font.pixelSize: 14

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (!mediaPill.activePlayer)
                        return;
                    if (mediaPill.activePlayer.isPlaying)
                        mediaPill.activePlayer.pause();
                    else
                        mediaPill.activePlayer.play();
                }
            }
        }

        Text {
            id: nextIcon
            text: "󰒭"
            color: (mediaPill.activePlayer && mediaPill.activePlayer.canGoNext) ? Theme.textColor : Theme.inactiveTextColor
            font.pixelSize: 14

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mediaPill.activePlayer && mediaPill.activePlayer.canGoNext)
                        mediaPill.activePlayer.next();
                }
            }
        }
    }
}
