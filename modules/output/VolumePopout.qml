pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import "./../../widgets"
import "./../../config"
import "./../../services"

PopOutWindow {
    id: root

    implicitHeight: hostHeight + (2 * vPadding)
    implicitWidth: (3 * hostWidth) + (2 * hPadding)

    Item {
        anchors.fill: parent
        anchors.margins: Appearance.padding.smaller

        InteractiveView {
            id: leftBtn
            spacing: Appearance.spacing.small
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            content: MaterialIcon {
                text: Audio.muted ? "volume_off" : "volume_mute"
                hovered: leftBtn.hovered
                active: leftBtn.active
            }
            onClicked: Audio.toggleMuted()
        }

        InteractiveView {
            id: rightBtn
            spacing: Appearance.spacing.small
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            content: MaterialIcon {
                text: "volume_up"
                hovered: rightBtn.hovered
                active: rightBtn.active
            }
            onClicked: Audio.setVolume(1.0)
        }

        HorizontalSlider {
            id: slider
            anchors.left: leftBtn.right
            anchors.leftMargin: leftBtn.width > 0 ? Appearance.padding.smallest : 0
            anchors.right: rightBtn.left
            anchors.rightMargin: rightBtn.width > 0 ? Appearance.padding.smallest : 0
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            slideValue: Audio.volume
            onSlide: Audio.setVolume(newValue)
        }
    }
}
