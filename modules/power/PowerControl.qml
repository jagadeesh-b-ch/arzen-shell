pragma ComponentBehavior: Bound

import QtQuick 2.15
import Quickshell
import "./../../config"
import "./../../widgets"
import "./../../services"

Item {
    id: root
    width: powerControl.width
    height: powerControl.height

    InteractiveView {
        id: powerControl
        popoutManagerExempt: true

        MaterialIconPadded {
            text: "\uE8AC"
            active: powerControl.active
            hovered: powerControl.hovered
        }

        onClicked: {
            if (PopOutManager.currentPopOut === powerPopout) {
                PopOutManager.hide(powerPopout);
            } else {
                PopOutManager.show(powerPopout);
            }
        }
    }

    PopOutWindow {
        id: powerPopout
        anchor.item: root
        hostWidth: powerControl.width
        hostHeight: powerControl.height

        implicitWidth: optionsMenu.width
        implicitHeight: optionsMenu.height

        Item {
            id: optionsWrapper
            width: optionsMenu.width
            height: optionsMenu.height

            MenuList {
                id: optionsMenu
                frosted: false

                PowerMenuEntry { icon: "lock"; text: "Lock"; cmd: ["quickshell", "-p", "/home/jaggu/Projects/arzen-shell/lock.qml"] }
                PowerMenuEntry { icon: "logout"; text: "Log off"; cmd: ["loginctl", "terminate-user", "$USER"] }
                PowerMenuEntry { icon: "nightlight"; text: "Suspend"; cmd: ["systemctl", "suspend"] }
                PowerMenuEntry { icon: "bedtime"; text: "Hibernate"; cmd: ["systemctl", "hibernate"] }
                PowerMenuEntry { icon: "restart_alt"; text: "Restart"; cmd: ["systemctl", "reboot"] }
                PowerMenuEntry { icon: "power_off"; text: "Shutdown"; cmd: ["systemctl", "poweroff"] }
            }
        }
    }
}
