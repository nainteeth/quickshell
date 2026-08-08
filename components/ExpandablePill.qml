import QtQuick
import QtQuick.Layouts
import ".."

Pill {
    id: root

    property string widgetName: ""
    useHoverColor: !isExpanded

    readonly property bool isExpanded: GlobalState.expandedWidget === widgetName

    Layout.preferredHeight: implicitHeight
    Layout.preferredWidth: implicitWidth

    clip: true

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
