import QtQuick 2.15
import "./../../config"
import "./../../widgets"
import "./../../utils"
import "./../../services"

InteractiveView {
    id: root
    onClicked: Hyprland.dispatch(`hl.dsp.exec_cmd("${DefaultApps.terminal} -e ${DefaultApps.network}", { tag = "bar_launch" })`)
    MaterialIconPadded {
        text: Network.active ? Icons.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
        anchors.verticalCenter: parent.verticalCenter
        active: root.active
        hovered: root.hovered
    }
}
