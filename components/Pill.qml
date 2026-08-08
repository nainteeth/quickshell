import QtQuick
import QtQuick.Controls
import ".."

Control {
    id: root
    default property alias content: root.contentItem
    property alias radius: bg.radius
    property alias color: bg.color
    property alias border: bg.border
    property bool useHoverColor: true
    leftPadding: 12
    rightPadding: 12
    topPadding: 6
    bottomPadding: 6

    signal clicked

    contentItem: Item {}

    background: Rectangle {
        id: bg
        color: (pillMouseArea.containsMouse && root.useHoverColor) ? Theme.hoverBackgroundColor : Theme.backgroundColor
        implicitHeight: Theme.barHeight
        radius: 12
        border.color: Theme.borderColor
        border.width: 1

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        MouseArea {
            id: pillMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.clicked();
            }
        }
    }
}
