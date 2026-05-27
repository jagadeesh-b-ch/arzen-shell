import QtQuick 2.15
import "./../../widgets"

StyledView {
    Item {
        implicitWidth: wifiControl.width + bluetoothControl.width
        implicitHeight: Math.max(wifiControl.height, bluetoothControl.height)
        WifiControl {
            id: wifiControl
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
        }
        BluetoothControl {
            id: bluetoothControl
            anchors.left: wifiControl.right
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
