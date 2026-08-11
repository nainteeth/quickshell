pragma Singleton // Defines this as a Singleton: https://doc.qt.io/qt-6/qml-singleton.html
import QtQuick
import QtCore

Item {
    property var expandedWidget: null  // null means nothing is expanded
    property bool launcherOpen: false
}
