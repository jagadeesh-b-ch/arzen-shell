import Quickshell
import Quickshell.Wayland
import QtQuick
import "./../config"

// @suppress uncreatable-type
PanelWindow {
    id: stylePanel
    required property string name
    property string bgColor: Appearance.defaults.backgroundColor
    property bool frosted: true
    color: "transparent"
    WlrLayershell.namespace: `archie-${name}`

    Rectangle {
        anchors.fill: parent
        color: stylePanel.bgColor
        opacity: stylePanel.frosted ? 0.35 : 0.8
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.12)
        border.width: stylePanel.frosted ? 1 : 0
    }
}
