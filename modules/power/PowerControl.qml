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

        implicitWidth: optionsWrapper.width
        implicitHeight: optionsWrapper.height

        Item {
            id: optionsWrapper
            width: optionsMenu.width + 2 * Appearance.defaults.hPadding
            height: optionsMenu.height + 2 * Appearance.defaults.vPadding

            MenuOptionList {
                id: optionsMenu
                x: Appearance.defaults.hPadding
                y: Appearance.defaults.vPadding
                model: [
                    QtObject { property string icon: "lock"; property string text: "Lock"; property var cmd: ["quickshell", "-p", "/home/jaggu/.config/quickshell/locker/shell.qml"] },
                    QtObject { property string icon: "logout"; property string text: "Log off"; property var cmd: ["loginctl", "terminate-user", "$USER"] },
                    QtObject { property string icon: "nightlight"; property string text: "Suspend"; property var cmd: ["systemctl", "suspend"] },
                    QtObject { property string icon: "bedtime"; property string text: "Hibernate"; property var cmd: ["systemctl", "hibernate"] },
                    QtObject { property string icon: "restart_alt"; property string text: "Restart"; property var cmd: ["systemctl", "reboot"] },
                    QtObject { property string icon: "power_off"; property string text: "Shutdown"; property var cmd: ["systemctl", "poweroff"] }
                ]
            }
        }
    }
}
