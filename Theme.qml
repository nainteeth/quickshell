pragma Singleton
import QtQuick

QtObject {
    id: attributes

    property bool isDark: true

    // Adwaita colors
    property color barColor: "transparent"
    property color textColor: isDark ? "#ffffff" : "#000000"
    property color inactiveTextColor: "#9a9996"
    property color backgroundColor: isDark ? "#1e1e1e" : "#ffffff"
    property color borderColor: isDark ? "#383838" : "#d1d1d1"
    property color hoverBackgroundColor: isDark ? "#303030" : "#f2f2f2"

    property int barHeight: 32
    property int trayIconSize: 20
    property int workspaceIconSize: 32
    property int batteryTextSize: 22
    property var locale: Qt.locale("de_DE")
}
