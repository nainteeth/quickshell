pragma Singleton
import QtQuick

QtObject {
    id: attributes

    property bool isDark

    // Adwaita colors
    property real pillOpacity: 0.7
    property color barColor: "transparent"
    property color textColor: isDark ? "#ffffff" : "#000000"
    property color inactiveTextColor: "#9a9996"
    property color backgroundColor: isDark ? Qt.rgba(0.117, 0.117, 0.117, pillOpacity) : Qt.rgba(1, 1, 1, pillOpacity)
    property color borderColor: isDark ? "#383838" : "#d1d1d1"
    property color hoverBackgroundColor: isDark ? Qt.rgba(0.188, 0.188, 0.188, pillOpacity) : Qt.rgba(0.949, 0.949, 0.949, pillOpacity)

    property int barHeight: 32
    property int trayIconSize: 20
    property int workspaceIconSize: 32
    property int batteryTextSize: 22
    property var locale: Qt.locale("de_DE")
}
