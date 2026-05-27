import QtQuick 2.15
import "./../../config"
import "./../../widgets"
import "./../../services"

InteractiveView {
    id: root
    z: 10
    onClicked: Hyprland.dispatch(`hl.dsp.exec_cmd("${DefaultApps.terminal} -e ${DefaultApps.bluetooth}", { tag = "bar_launch" })`)
    MaterialIconPadded {
        text: Bluetooth.powered ? "bluetooth" : "bluetooth_disabled"
        active: root.active
        hovered: root.hovered
    }
}
