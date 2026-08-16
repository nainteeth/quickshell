import QtQuick
import QtQuick.Layouts
import ".."

// Base component for widgets that expand when clicked.
// Widgets using this must define collapsedContent and expandedContent
// This component uses Pill as a base.
Pill {
    id: root

    // Content shown when collapsed
    required property Component collapsedContent
    // Content shown when expanded
    required property Component expandedContent

    // Disables hover color when expanded.
    useHoverColor: !isExpanded

    // Checks if this widget itself is active in the global state.
    readonly property bool isExpanded: GlobalState.expandedWidget === root

    // This prevents the pills content to clip outside the pill during the animation.
    // It is needed since the pills content updates instantly while the pill itself needs time for the animation.
    clip: true

    // The contentItem is the Item (any object) that is inside the pill
    contentItem: Item {
        // These lines adjust the size of the content based on te current state.
        // This also resizes the Pill itself since the size of the pill adjusts to its content
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
            easing.type: Easing.InOutCubic
        }
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
        }
    }

    // Toggles the global expanded state. This Singleton stores the expanded widget directly and can only store a single widget at a time. Therefore if you expand a widget while another one is already expanded, it gets overwritten and the first widget closes. This is intended behaviour so you don't have to manually close all the widgets you expand.
    onClicked: {
        GlobalState.expandedWidget = isExpanded ? null : root;
    }
}
