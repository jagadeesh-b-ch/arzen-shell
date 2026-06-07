import QtQuick
import "./../config"

Rectangle {
    id: root
    property int spacing: Appearance.padding.smallest
    property bool frosted: true
    property real frostedOpacity: 0.7
    property bool fillWidth: false
    property bool backgroundVisible: true
    property real minimumWidth: 0
    property real minimumHeight: 0
    readonly property alias contentItem: contentLoader.item

    width: Math.max(contentLoader.implicitWidth + (2 * spacing), minimumWidth)
    height: Math.max(contentLoader.implicitHeight + (2 * spacing), minimumHeight)
    radius: Appearance.defaults.rounding
    color: root.frosted ? "transparent" : Appearance.defaults.surfaceColor

    default property alias content: contentLoader.sourceComponent

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: Appearance.defaults.surfaceColor
        opacity: root.frosted ? root.frostedOpacity : 0
        visible: root.backgroundVisible
    }

    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.12)
        border.width: root.frosted ? 1 : 0
        visible: root.backgroundVisible
    }

    Item {
        anchors.fill: parent
        anchors.margins: root.spacing
        Loader {
            id: contentLoader
            anchors.fill: root.fillWidth ? parent : undefined
        }
    }
}
