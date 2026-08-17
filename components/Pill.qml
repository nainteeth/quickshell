import QtQuick
import QtQuick.Controls
import ".."

// Base UI component for the shell.
// Pretty much everything uses this so it's important to properly understand
Control { // Read: https://doc.qt.io/qt-6/qml-qtquick-controls-control.html#details
    id: root

    // Allows adding child items directly without typing contentItem.
    default property alias content: root.contentItem

    // Exposes background visual properties for overrides.
    property alias radius: bg.radius
    property alias color: bg.color
    property alias border: bg.border

    // Toggles hover color changes.
    property bool useHoverColor: true

    // Toggles mouse interaction and click animations.
    property bool clickable: true

    // Default internal margins.
    leftPadding: 12
    rightPadding: 12
    topPadding: 6
    bottomPadding: 6

    // Emits when the widget is clicked.
    signal clicked

    contentItem: Item {} // This can be anything you want to put in the pill

    background: Rectangle { // This is the pill itself
        id: bg

        // Sets background color based on hover state.
        color: (pillMouseArea.containsMouse && root.useHoverColor) ? Theme.hoverBackgroundColor : Theme.backgroundColor

        // Shrinks the widget slightly when pressed.
        scale: pillMouseArea.pressed ? 0.96 : 1.0

        // Click animation speed and curve.
        Behavior on scale {
            NumberAnimation {
                duration: 80
                easing.type: Easing.OutCubic
            }
        }

        // You can try to match this to your compositors settings to match the style
        // My goal during designing this pill was to make the pills look like
        // small windows/terminals themselves
        radius: 12
        border.color: Theme.borderColor
        border.width: 1

        // Hover color transition speed.
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        // Captures mouse inputs and forwards the click signal.
        MouseArea {
            id: pillMouseArea
            anchors.fill: parent
            enabled: root.clickable
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                root.clicked();
            }
        }
    }
}
