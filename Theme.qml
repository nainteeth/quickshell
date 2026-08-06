pragma Singleton
import QtQuick

QtObject {
    id: attributes
    property color barColor: "#000000"
    property color textColor: "#C0C0C0"
    property color inactiveTextColor: "#888888"
    property color backgroundColor: "#000000"
    property color borderColor: "#ffffff"
    property int barHeight: 24
    property int trayIconSize: 20
    property int workspaceIconSize: 32
    property int batteryTextSize: 22
    property var locale: Qt.locale("de_DE")
}
