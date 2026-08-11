import QtQuick
import QtQuick.Layouts
import ".."

// Base component for widgets that expand when clicked.
Pill {
    id: root

    // Unique identifier for the widget.
    // This is used in the global state to check which widget is expanded.
    // By storing the active widget name globally there can only ever be
    // a single ExpandablePill expanded at a time.
    property string widgetName: ""

    // ExpandablePill always expects separate collapsed and expanded views.
    required property Component collapsedContent
    required property Component expandedContent

    // Disables hover color when expanded.
    useHoverColor: !isExpanded

    // Checks if this widget is active in the global state.
    readonly property bool isExpanded: GlobalState.expandedWidget === widgetName

    // This prevents the pills content to clip outside the pill during the animation.
    // It is needed since the pills content updates instantly while the pill itself needs time for the animation.
    clip: true

    contentItem: Item {
        // These lines adjust the size of the pill based on te current state.
        implicitWidth: root.isExpanded ? expandedLoader.implicitWidth : collapsedLoader.implicitWidth
        implicitHeight: root.isExpanded ? expandedLoader.implicitHeight : collapsedLoader.implicitHeight

        // The loaders are used to load/render the pill based on the current state. What they actually create is based on the sourceComponent which is received from the specific widget.
        Loader {
            id: collapsedLoader
            anchors.centerIn: parent
            visible: !root.isExpanded
            // The sourceComponent looks at the required collapsedContent property of the specific widget and loads it into the loader.
            sourceComponent: root.collapsedContent
        }

        Loader {
            id: expandedLoader
            anchors.centerIn: parent
            visible: root.isExpanded
            // Same thing as above but for the expandedContent property.
            sourceComponent: root.expandedContent
        }
    }

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
