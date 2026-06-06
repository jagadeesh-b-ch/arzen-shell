import QtQuick 2.15
import "./../../widgets"
import "./../../config"

StyledView {
    id: root

    Item {
        implicitWidth: batteryControl.width + powerProfileControl.width + powerButtonControl.width
        implicitHeight: Math.max(batteryControl.height, powerProfileControl.height, powerButtonControl.height)

        BatteryControl {
            id: batteryControl
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }

        PowerProfile {
            id: powerProfileControl
            anchors.left: batteryControl.right
            anchors.verticalCenter: parent.verticalCenter
        }

        PowerControl {
            id: powerButtonControl
            anchors.left: powerProfileControl.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
