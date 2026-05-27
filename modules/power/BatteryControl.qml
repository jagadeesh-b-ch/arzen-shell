pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Layouts
import Quickshell.Services.UPower
import "./../../widgets"
import "./../../config"
import "./../../utils"

InteractiveView {
    id: root
    property int batteryPercentage: UPower.displayDevice.percentage * 100
    RowLayout {
        spacing: Appearance.padding.smallest
        StyledTextPadded {
            rightPadding: 0
            Layout.alignment: Qt.AlignVCenter
            text: root.batteryPercentage + "%"
            active: root.active
            hovered: root.hovered
        }
        MaterialIconPadded {
            leftPadding: 0
            Layout.alignment: Qt.AlignVCenter
            text: Icons.getBatteryIcon(root.batteryPercentage, UPower.displayDevice.state === UPowerDeviceState.Charging)
            active: root.active
            hovered: root.hovered
        }
    }
}
