import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import ".."
import "../components"

PanelWindow {
    id: notifWindow

    anchors {
        top: true
        right: true
    }
    margins {
        top: 12
        right: 12
    }

    exclusiveZone: 0
    color: "transparent"
    implicitWidth: notifPill.width
    implicitHeight: notifPill.height
    visible: false

    property string notifAppName: ""
    property string notifSummary: ""
    property string notifBody: ""

    NotificationServer {
        id: notifServer
        onNotification: notification => {
            notifWindow.notifAppName = notification.appName;
            notifWindow.notifSummary = notification.summary;
            notifWindow.notifBody = notification.body;
            notifWindow.visible = true;
            dismissTimer.restart();
        }
    }

    Timer {
        id: dismissTimer
        interval: 6000
        onTriggered: notifWindow.visible = false
    }

    Pill {
        id: notifPill

        Column {
            spacing: 4
            Text {
                text: notifWindow.notifAppName
                color: Theme.textColor
                font.pixelSize: 12
                font.bold: true
            }
            Text {
                text: notifWindow.notifSummary
                color: Theme.textColor
                font.pixelSize: 14
            }
            Text {
                text: notifWindow.notifBody
                color: Theme.textColor
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                width: 200
            }
        }
    }
}
