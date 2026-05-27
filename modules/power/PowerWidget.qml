import QtQuick 2.15
import "./../../widgets"

StyledView {
    Item {
        implicitWidth: powerProfile.width + batteryControl.width + powerControl.width
        implicitHeight: Math.max(powerProfile.height, batteryControl.height, powerControl.height)
        PowerProfile {
            id: powerProfile
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
        BatteryControl {
            id: batteryControl
            anchors.left: powerProfile.right
            anchors.verticalCenter: parent.verticalCenter
        }
        PowerControl {
            id: powerControl
            anchors.left: batteryControl.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
