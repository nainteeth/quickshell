import QtQuick

Rectangle {
    color: "#000000"
    height: 24
    width: contentItem.width + 12
    radius: 12
    border.color: "#ffffff"
    border.width: 1

    Item {
        id: contentItem
        anchors.centerIn: parent
        width: childrenRect.width
        height: childrenRect.height
    }

    default property alias content: contentItem.data
}
