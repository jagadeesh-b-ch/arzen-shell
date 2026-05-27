pragma ComponentBehavior: Bound

import Quickshell
import QtQuick 2.15
import QtQuick.Layouts
import "./../../widgets"
import "./../../config"
import "./../../utils"
import "./../../services"

Item {
    id: root

    property ShellScreen currentScreen
    property Brightness.Monitor monitor: Brightness.getMonitorForScreen(currentScreen)
    property int readableBrightness: (monitor.brightness * 100)

    width: brightnessView.width
    height: brightnessView.height

    InteractiveView {
        id: brightnessView
        popoutManagerExempt: true
        content: Item {
            id: brightnessContent
            readonly property real fixedTextWidth: brightnessMetric.width + Appearance.defaults.hPadding

            implicitWidth: fixedTextWidth + brightnessIcon.implicitWidth + rowLayout.spacing
            implicitHeight: rowLayout.implicitHeight

            TextMetrics {
                id: brightnessMetric
                font.family: Appearance.defaults.fontFamily
                font.pointSize: Appearance.defaults.fontSize
                text: "100"
            }

            RowLayout {
                id: rowLayout
                spacing: Appearance.padding.smallest
                anchors.centerIn: parent

                StyledTextPadded {
                    text: root.readableBrightness
                    rightPadding: 0
                    Layout.preferredWidth: brightnessContent.fixedTextWidth
                    horizontalAlignment: Text.AlignRight
                    active: brightnessView.active
                    hovered: brightnessView.hovered
                    Layout.alignment: Qt.AlignVCenter
                }

                MaterialIconPadded {
                    id: brightnessIcon
                    text: Icons.getBrightnessIcon(root.readableBrightness)
                    leftPadding: 0
                    active: brightnessView.active
                    hovered: brightnessView.hovered
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        onClicked: {
            if (PopOutManager.currentPopOut === brightnessSlider) {
                PopOutManager.hide(brightnessSlider);
            } else {
                PopOutManager.show(brightnessSlider);
            }
        }
    }

    HorizontalSlider {
        id: brightnessSlider
        anchor.item: root

        slideValue: root.monitor.brightness
        onSlide: newBrightness => {
            root.monitor.setBrightness(newBrightness);
        }

        hostWidth: brightnessView.width
        hostHeight: brightnessView.height
    }
}
