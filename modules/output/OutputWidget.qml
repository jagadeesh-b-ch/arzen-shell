pragma ComponentBehavior: Bound

import Quickshell
import QtQuick 2.15
import "./../../widgets"

StyledView {
    id: root
    property ShellScreen currentScreen
    Item {
        implicitWidth: volumeControl.width + brightnessControl.width
        implicitHeight: Math.max(volumeControl.height, brightnessControl.height)
        VolumeControl {
            id: volumeControl
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
        BrightnessControl {
            id: brightnessControl
            currentScreen: root.currentScreen
            anchors.left: volumeControl.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
