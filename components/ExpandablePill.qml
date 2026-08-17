import QtQuick
import QtQuick.Layouts
import ".."

// Base component for widgets that expand on hover.
// Widgets using this must define collapsedItem and expandedItem.
// This component uses Pill as a base.
Pill {
    id: root

    // Content shown when collapsed/expanded.
    required property Item collapsedItem
    required property Item expandedItem

    // Disables hover color when expanded.
    useHoverColor: !isExpanded

    // Hover-driven expansion.
    readonly property bool isExpanded: root.hovered

    // This prevents the pills content to clip outside the pill during the animation.
    // It is needed since the pills content updates instantly while the pill itself needs time for the animation.
    clip: true

    contentItem: Item {
        implicitWidth: root.isExpanded ? expandedItemWrap.implicitWidth : collapsedItemWrap.implicitWidth
        implicitHeight: root.isExpanded ? expandedItemWrap.implicitHeight : collapsedItemWrap.implicitHeight

        Item { // This is a wrapper for the collapsed item. It is needed to animate the scale and opacity of the collapsed item without affecting the expanded item.
            id: collapsedItemWrap
            anchors.centerIn: parent
            implicitWidth: collapsedContainer.implicitWidth
            implicitHeight: collapsedContainer.implicitHeight
            opacity: root.isExpanded ? 0 : 1
            scale: root.isExpanded ? 0.96 : 1.0
            visible: opacity > 0.01
            transformOrigin: Item.Center

            Behavior on scale {
                NumberAnimation {
                    duration: 400
                    easing.type: Easing.InOutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.InOutCubic
                }
            }

            Item {
                id: collapsedContainer
                implicitWidth: root.collapsedItem ? root.collapsedItem.implicitWidth : 0
                implicitHeight: root.collapsedItem ? root.collapsedItem.implicitHeight : 0
                Component.onCompleted: {
                    if (root.collapsedItem)
                        root.collapsedItem.parent = collapsedContainer;
                }
            }
        }

        Item { // Another wrapper for the expanded item. It is needed to animate the scale and opacity of the expanded item without affecting the collapsed item.
            id: expandedItemWrap
            anchors.centerIn: parent
            implicitWidth: expandedContainer.implicitWidth
            implicitHeight: expandedContainer.implicitHeight
            transformOrigin: Item.Center
            scale: root.isExpanded ? 1.0 : 0.96
            opacity: root.isExpanded ? 1.0 : 0.0
            visible: opacity > 0.01

            Behavior on scale {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.InOutCubic
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InOutCubic
                }
            }

            Item {
                id: expandedContainer
                implicitWidth: root.expandedItem ? root.expandedItem.implicitWidth : 0
                implicitHeight: root.expandedItem ? root.expandedItem.implicitHeight : 0
                Component.onCompleted: {
                    if (root.expandedItem)
                        root.expandedItem.parent = expandedContainer;
                }
            }
        }
    }

    // Animation speed and curve for size changes.
    Behavior on implicitHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutCubic
        }
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutCubic
        }
    }
}
