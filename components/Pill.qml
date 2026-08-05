import QtQuick
import ".."

Rectangle {
    id: root
    color: Theme.backgroundColor
    implicitHeight: 24
    implicitWidth: contentItem.width + 12
    radius: 12
    border.color: Theme.borderColor
    border.width: 1

    signal clicked

    Item {
        id: contentItem
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
    }

    MouseArea {
        anchors.fill: parent
        z: -1 // this changes the priority of the MouseArea to be lower than the children, so that children can handle their own clicks first
        onClicked: {
            console.log("Pill's own MouseArea fired");
            root.clicked();
        }
    }

    // Makes unlabeled children become children of contentItem automatically.
    default property alias content: contentItem.data
}
