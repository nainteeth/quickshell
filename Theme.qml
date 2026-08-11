pragma Singleton
import QtQuick
import QtCore

Item {
    // Only the properties of the root object are exposed which is why there is an alias
    property alias isDark: settings.isDark

    Settings { // these settings are persistent
        id: settings
        location: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/config/settings.conf"
        property bool isDark: false
    }

    // Adwaita colors
    property real pillOpacity: 0.8
    property color barColor: "transparent"
    property color textColor: settings.isDark ? "#ffffff" : "#000000"
    property color inactiveTextColor: "#9a9996"
    property color backgroundColor: settings.isDark ? Qt.rgba(0.117, 0.117, 0.117, pillOpacity) : Qt.rgba(1, 1, 1, pillOpacity)
    property color borderColor: settings.isDark ? "#383838" : "#d1d1d1"
    property color hoverBackgroundColor: settings.isDark ? Qt.rgba(0.188, 0.188, 0.188, pillOpacity) : Qt.rgba(0.949, 0.949, 0.949, pillOpacity)

    property int barHeight: 32
    property int trayIconSize: 20
    property int workspaceIconSize: 32
    property int batteryTextSize: 22
    property var locale: Qt.locale("de_DE")
}
