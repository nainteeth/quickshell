import QtQuick
import Quickshell.Services.Mpris
import ".."
import "../components"

Pill {
    id: mediaPill

    readonly property var players: Mpris.players.values

    // This goes through the list of MPRIS players and returns the first one that is currently playing.
    // If none are playing, it returns the first player in the list, or null if there are no players.
    readonly property var activePlayer: {
        let playingPlayer = mediaPill.players.find(player => player.isPlaying);
        // If a player is playing, return that player.
        if (playingPlayer)
            return playingPlayer;
        else
            // Otherwise, return the first player in the list, or null if there are no players.
            return mediaPill.players[0] ?? null;
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
