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
    property int borderWidth: 1
    color: "transparent"
    WlrLayershell.namespace: `archie-${name}`

    Item {
        anchors.fill: parent
        opacity: 0.3

        Rectangle {
            anchors.fill: parent
            color: stylePanel.bgColor
            opacity: stylePanel.frosted ? Appearance.defaults.frostedOpacity : 0.8
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: Qt.rgba(1, 1, 1, 0.12)
            border.width: stylePanel.frosted ? stylePanel.borderWidth : 0
        }
    }
}
