pragma Singleton
import QtQuick
import QtCore

Item {
    Settings {
        id: settings
        // these settings are persistent
        location: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/config/settings.conf"
        // default theme if nothing else was saved yet
        property string themeName: "dark"
    }

    // all available themes live in this object
    readonly property var themes: ({
            "dark": {
                name: "Dark",
                isDark: true,
                textColor: "#ffffff",
                inactiveTextColor: "#9a9996",
                backgroundBaseColor: "#000000",
                borderColor: "#383838",
                hoverBackgroundBaseColor: "#303030"
            },
            "light": {
                name: "Light",
                isDark: false,
                textColor: "#000000",
                inactiveTextColor: "#6b6b6b",
                backgroundBaseColor: "#ffffff",
                borderColor: "#45475a",
                hoverBackgroundBaseColor: "#f2f2f2"
            },
            "catppuccin-dark": {
                name: "Catppuccin Dark",
                isDark: true,
                textColor: "#cdd6f4",
                inactiveTextColor: "#6c7086",
                backgroundBaseColor: "#1e1e2e",
                borderColor: "00000000",
                hoverBackgroundBaseColor: "#313244"
            },
            "catppuccin-light": {
                name: "Catppuccin Light",
                isDark: false,
                textColor: "#4c4f69",
                inactiveTextColor: "#8c8fa1",
                backgroundBaseColor: "#eff1f5",
                borderColor: "00000000",
                hoverBackgroundBaseColor: "#e6e9ef"
            },
            "adwaita-dark": {
                name: "Adwaita Dark",
                isDark: true,
                textColor: "#ffffff",
                inactiveTextColor: "#9a9996",
                backgroundBaseColor: "#303030",
                borderColor: "#4a4a4a",
                hoverBackgroundBaseColor: "#3a3a3a"
            },
            "compline-dark": {
                name: "Compline",
                isDark: true,
                textColor: "#f0efeb",
                inactiveTextColor: "#ccc4b4",
                backgroundBaseColor: "#1a1d21",
                borderColor: "#f0efeb",
                hoverBackgroundBaseColor: "#515761"
            },
            "lauds-light": {
                name: "Lauds",
                isDark: false,
                textColor: "#1a1d21",
                inactiveTextColor: "#4a4d51",
                backgroundBaseColor: "#f0efeb",
                borderColor: "#1a1d21",
                hoverBackgroundBaseColor: "#7d7a75"
            }
        })

    // this is used by the theme switcher as the repeaters model to show a button for each theme
    readonly property var themeNames: ["dark", "light", "catppuccin-dark", "catppuccin-light", "adwaita-dark", "compline-dark", "lauds-light"]

    // exposes the saved theme name on the root object. This is needed because the stuff in the settings object is not accessable from outside this file
    property alias themeName: settings.themeName

    // This assigns the currently selected theme object to a property so that the shell can read the colors from it. This is used in the shell to style all the widgets and stuff. For example: You can now access the text color of the currently selected theme with Theme.currentTheme.textColor. Very nice!
    readonly property var currentTheme: themes[settings.themeName]

    property bool isDark: currentTheme.isDark
    // nice readable name for stuff like the theme switcher pill
    readonly property string themeDisplayName: currentTheme.name

    property real pillOpacity: 0.8
    property color barColor: "transparent"
    // from here on the shell just reads colors from the currently selected theme
    property color textColor: currentTheme.textColor
    property color inactiveTextColor: currentTheme.inactiveTextColor
    // This applies the opacity directly to the background color
    property color backgroundColor: Qt.alpha(currentTheme.backgroundBaseColor, pillOpacity)
    property color borderColor: currentTheme.borderColor
    property color hoverBackgroundColor: Qt.alpha(currentTheme.hoverBackgroundBaseColor, pillOpacity)

    property int barHeight: 32
    property int trayIconSize: 20
    property int workspaceIconSize: 32
    property int batteryTextSize: 22
    property var locale: Qt.locale("de_DE")

    function setTheme(newThemeName) {
        // only switch if the requested theme actually exists
        if (themes[newThemeName]) // This simply checks if it is not undefined.
            settings.themeName = newThemeName;
    }
}
