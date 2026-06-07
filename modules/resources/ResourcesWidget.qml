pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import "./../../config"
import "./../../widgets"
import "./../../services"

StyledView {
    id: root
    spacing: 0

    InteractiveView {
        id: interactiveView
        spacing: Appearance.padding.smallest

        property string cpu: `${Resources.cpuUsage}%`
        property string ram: `${Resources.usedRam.toFixed(2)}/${Resources.totalRam.toFixed(2)}G`
        property string temp: `${Resources.cpuTemp}\u00B0C`

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
                        text: interactiveView.cpu
                        width: cpuMetric.width
                        horizontalAlignment: Text.AlignRight
                        active: interactiveView.active
                        hovered: interactiveView.hovered
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MaterialIcon {
                        id: cpuIcon
                        text: "memory"
                        active: interactiveView.active
                        hovered: interactiveView.hovered
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    id: ramRow
                    spacing: rowSpacing
                    width: ramRowWidth
                    StyledText {
                        id: ramText
                        text: interactiveView.ram
                        width: ramMetric.width
                        horizontalAlignment: Text.AlignRight
                        active: interactiveView.active
                        hovered: interactiveView.hovered
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MaterialIcon {
                        id: ramIcon
                        text: "memory_alt"
                        active: interactiveView.active
                        hovered: interactiveView.hovered
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Row {
                    id: tempRow
                    spacing: rowSpacing
                    width: tempRowWidth
                    StyledText {
                        id: tempText
                        text: interactiveView.temp
                        width: tempMetric.width
                        horizontalAlignment: Text.AlignRight
                        active: interactiveView.active
                        hovered: interactiveView.hovered
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MaterialIcon {
                        id: tempIcon
                        text: "device_thermostat"
                        active: interactiveView.active
                        hovered: interactiveView.hovered
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
