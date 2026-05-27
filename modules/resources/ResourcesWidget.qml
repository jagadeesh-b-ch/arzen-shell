pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "./../../config"
import "./../../widgets"
import "./../../services"

InteractiveView {
    id: root

    property string cpu: `${Resources.cpuUsage}%`
    property string ram: `${Resources.usedRam.toFixed(2)}/${Resources.totalRam.toFixed(2)}G`
    property string temp: `${Resources.cpuTemp}\u00B0C`

    spacing: Appearance.padding.smallest

    onClicked: Hyprland.dispatch(`hl.dsp.exec_cmd("${DefaultApps.terminal} -e ${DefaultApps.resourceMonitor}", { tag = "bar_launch" })`)

    content: Item {
        readonly property real rowSpacing: 1
        readonly property real cpuRowWidth: cpuMetric.width + cpuIcon.implicitWidth + rowSpacing
        readonly property real ramRowWidth: ramMetric.width + ramIcon.implicitWidth + rowSpacing
        readonly property real tempRowWidth: tempMetric.width + tempIcon.implicitWidth + rowSpacing

        implicitWidth: cpuRowWidth + ramRowWidth + tempRowWidth + resources.spacing * 2 + 2 * Appearance.defaults.hPadding
        implicitHeight: resources.implicitHeight + 2 * Appearance.defaults.vPadding

        TextMetrics {
            id: cpuMetric
            font.family: Appearance.defaults.fontFamily
            font.pointSize: Appearance.defaults.fontSize
            text: "100%"
        }

        TextMetrics {
            id: ramMetric
            font.family: Appearance.defaults.fontFamily
            font.pointSize: Appearance.defaults.fontSize
            text: "99.99/99.99G"
        }

        TextMetrics {
            id: tempMetric
            font.family: Appearance.defaults.fontFamily
            font.pointSize: Appearance.defaults.fontSize
            text: "100.0\u00B0C"
        }

        RowLayout {
            id: resources
            spacing: 0
            anchors.centerIn: parent

            Row {
                id: cpuRow
                spacing: rowSpacing
                width: cpuRowWidth
                StyledText {
                    id: cpuText
                    text: root.cpu
                    width: cpuMetric.width
                    horizontalAlignment: Text.AlignRight
                    active: root.active
                    hovered: root.hovered
                    anchors.verticalCenter: parent.verticalCenter
                }
                MaterialIcon {
                    id: cpuIcon
                    text: "memory"
                    active: root.active
                    hovered: root.hovered
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                id: ramRow
                spacing: rowSpacing
                width: ramRowWidth
                StyledText {
                    id: ramText
                    text: root.ram
                    width: ramMetric.width
                    horizontalAlignment: Text.AlignRight
                    active: root.active
                    hovered: root.hovered
                    anchors.verticalCenter: parent.verticalCenter
                }
                MaterialIcon {
                    id: ramIcon
                    text: "memory_alt"
                    active: root.active
                    hovered: root.hovered
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Row {
                id: tempRow
                spacing: rowSpacing
                width: tempRowWidth
                StyledText {
                    id: tempText
                    text: root.temp
                    width: tempMetric.width
                    horizontalAlignment: Text.AlignRight
                    active: root.active
                    hovered: root.hovered
                    anchors.verticalCenter: parent.verticalCenter
                }
                MaterialIcon {
                    id: tempIcon
                    text: "device_thermostat"
                    active: root.active
                    hovered: root.hovered
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
