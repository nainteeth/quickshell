import QtQuick
import QtQuick.Layouts
import ".."

Pill {
    id: root

    property string widgetName: ""
    property int expandedHeight: 120
    property int expandedWidth: 200
    property int collapsedWidth: 50

    readonly property bool isExpanded: GlobalState.expandedWidget === widgetName

    implicitHeight: isExpanded ? expandedHeight : Theme.barHeight
    implicitWidth: isExpanded ? expandedWidth : collapsedWidth

    Layout.preferredHeight: implicitHeight
    Layout.preferredWidth: implicitWidth

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

    onClicked: {
        GlobalState.expandedWidget = isExpanded ? "" : widgetName;
    }
}
