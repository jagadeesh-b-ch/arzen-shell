pragma ComponentBehavior: Bound

import Quickshell
import QtQuick 2.15
import QtQuick.Layouts
import "./../../widgets"
import "./../../utils"
import "./../../config"
import "./../../services"

Item {
    id: root

    width: volumeView.width
    height: volumeView.height

    property int readableVolume: (Audio.volume * 100)

    InteractiveView {
        id: volumeView
        popoutManagerExempt: true
        content: Item {
            id: volumeContent
            readonly property real fixedTextWidth: volumeMetric.width + Appearance.defaults.hPadding

            implicitWidth: fixedTextWidth + volumeIcon.implicitWidth + rowLayout.spacing
            implicitHeight: rowLayout.implicitHeight

            TextMetrics {
                id: volumeMetric
                font.family: Appearance.defaults.fontFamily
                font.pointSize: Appearance.defaults.fontSize
                text: "100"
            }

            RowLayout {
                id: rowLayout
                spacing: Appearance.padding.smallest
                anchors.centerIn: parent

                StyledTextPadded {
                    text: root.readableVolume
                    leftPadding: Appearance.padding.smaller
                    rightPadding: 0
                    Layout.preferredWidth: volumeContent.fixedTextWidth
                    horizontalAlignment: Text.AlignRight
                    active: volumeView.active
                    hovered: volumeView.hovered
                    Layout.alignment: Qt.AlignVCenter
                }

                MaterialIconPadded {
                    id: volumeIcon
                    text: Icons.getVolumeIcon(root.readableVolume)
                    leftPadding: 0
                    rightPadding: Appearance.padding.smaller
                    active: volumeView.active
                    hovered: volumeView.hovered
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        onClicked: {
            if (PopOutManager.currentPopOut === volumeSlider) {
                PopOutManager.hide(volumeSlider);
            } else {
                PopOutManager.show(volumeSlider);
            }
        }
    }

    HorizontalSlider {
        id: volumeSlider
        anchor.item: root
        slideValue: Audio.volume
        onSlide: newVolume => {
            Audio.setVolume(newVolume);
        }
        hostWidth: volumeView.width
        hostHeight: volumeView.height
    }
}
