import QtQuick
import QtQuick.Controls
import "./../config"

Item {
    id: root

    property real slideValue: 0
    signal slide(real newValue)

    Slider {
        id: slider
        anchors.fill: parent

        from: 0.0
        to: 1.0
        value: root.slideValue

        handle: Rectangle {
            color: Appearance.defaults.primaryColor
            width: 16
            height: 16
            radius: 16 / 2
            y: (parent.height - height) / 2
            x: slider.visualPosition * (slider.width - width)
        }

        background: Item {
            anchors.fill: parent

            Rectangle {
                id: filledGroove
                height: 4
                radius: 2
                color: Appearance.defaults.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                width: slider.visualPosition * slider.width
            }
            Rectangle {
                id: unfilledGroove
                height: 4
                radius: 2
                color: Appearance.defaults.contentOnPrimaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: filledGroove.width
                width: slider.width - filledGroove.width
            }
        }

        onMoved: root.slide(value)
    }
}
