import QtQuick
import QtQuick.Layouts
import ".."

// Base component for widgets that expand when clicked.
Pill {
    id: root

    // Unique identifier for the widget.
    // This is used in the global state to check which widget is expanded
    property string widgetName: ""

    // Disables hover color when expanded.
    useHoverColor: !isExpanded

    // Checks if this widget is active in the global state.
    readonly property bool isExpanded: GlobalState.expandedWidget === widgetName

    // This prevents the pills content to clip outside the pill during the animation.
    // It is needed since the pills content updates instantly while the pill itself needs
    // time for the animation.
    clip: true

    // Animation speed and curve for size changes.
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    // Toggles the global expanded state.
    onClicked: {
        GlobalState.expandedWidget = isExpanded ? "" : widgetName;
    }
}
