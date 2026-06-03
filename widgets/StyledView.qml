import QtQuick
import "./../config"

Rectangle {
    id: root
    property int spacing: Appearance.padding.smallest
    property bool frosted: true

    width: contentLoader.implicitWidth + (2 * spacing)
    height: contentLoader.implicitHeight + (2 * spacing)
    radius: Appearance.defaults.rounding
    color: root.frosted ? "transparent" : Appearance.defaults.surfaceColor

    default property alias content: contentLoader.sourceComponent

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: Appearance.defaults.surfaceColor
        opacity: root.frosted ? 0.35 : 0
    }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.12)
        border.width: root.frosted ? 1 : 0
    }

    Item {
        anchors.fill: parent
        anchors.margins: root.spacing
        Loader {
            id: contentLoader
        }
    }
}
