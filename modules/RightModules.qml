import Quickshell
import QtQuick 2.15
import "./../config"
import "./resources"
import "./connectivity"
import "./power"
import "./output"

Row {
    id: root
    spacing: Appearance.defaults.spacing

    property ShellScreen currentScreen
    ResourcesWidget {
        id: resourcesWidget
        anchors.verticalCenter: parent.verticalCenter
    }

    ConnectivityWidget {
        id: connectivityWidget
        anchors.verticalCenter: parent.verticalCenter
    }

    OutputWidget {
        id: outputWidget
        anchors.verticalCenter: parent.verticalCenter
        currentScreen: root.currentScreen
    }

    WallpaperWidget {
        anchors.verticalCenter: parent.verticalCenter
        currentScreen: root.currentScreen
    }

    PowerWidget {
        anchors.verticalCenter: parent.verticalCenter
    }
}
