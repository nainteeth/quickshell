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
    property bool clickable: true
    leftPadding: 12
    rightPadding: 12
    topPadding: 6
    bottomPadding: 6

    signal clicked

    contentItem: Item {}

    background: Rectangle {
        id: bg
        color: (pillMouseArea.containsMouse && root.useHoverColor) ? Theme.hoverBackgroundColor : Theme.backgroundColor
        scale: pillMouseArea.pressed ? 0.96 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 80
                easing.type: Easing.OutCubic
            }
        }
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
            enabled: root.clickable
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.clicked();
            }
        }
    }
}
