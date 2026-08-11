pragma Singleton // Defines this as a Singleton: https://doc.qt.io/qt-6/qml-singleton.html
import QtQuick
import QtCore

Item {
    property string expandedWidget: ""  // "" means is nothing expanded
    property bool launcherOpen: false
}
