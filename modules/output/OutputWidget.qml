pragma ComponentBehavior: Bound

import Quickshell
import QtQuick 2.15
import QtQuick.Layouts
import "./../../config"
import "./../../widgets"

StyledView {
    id: root
    property ShellScreen currentScreen
    Row {
        spacing: 0
        VolumeControl {
            id: volumeControl
        }
        BrightnessControl {
            id: brightnessControl
            currentScreen: root.currentScreen
        }
    }
}
