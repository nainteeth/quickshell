pragma Singleton
import QtQuick
import QtCore

Item {
    Settings {
        id: settings
        location: StandardPaths.writableLocation(StandardPaths.ConfigLocation) + "/quickshell/config/settings.conf"
        property string appLaunchCountsJson: "{}"
    }

    property var appLaunchCounts: ({})

    Component.onCompleted: {
        loadLaunchCounts();
    }

    function loadLaunchCounts() {
        try {
            appLaunchCounts = JSON.parse(settings.appLaunchCountsJson);
        } catch (error) {
            appLaunchCounts = ({});
            settings.appLaunchCountsJson = "{}";
        }
    }

    function saveLaunchCounts() {
        settings.appLaunchCountsJson = JSON.stringify(appLaunchCounts);
    }

    function getLaunchCount(desktopFile) {
        return appLaunchCounts[desktopFile] ?? 0;
    }

    function incrementLaunchCount(desktopFile) {
        appLaunchCounts[desktopFile] = getLaunchCount(desktopFile) + 1;
        appLaunchCounts = Object.assign({}, appLaunchCounts);
        saveLaunchCounts();
    }
}
