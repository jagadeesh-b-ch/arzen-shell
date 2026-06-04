import QtQuick
import "./../config"
import "./../services"

Rectangle {
    id: root

    property int spacing: 0
    property bool active: false
    property bool hovered: false
    property bool popoutManagerExempt: false
    property bool frosted: true
    property bool fillWidth: false
    signal clicked
    signal hover(bool hovered)
    default property alias content: contentLoader.sourceComponent

    width: interactiveView.width + (2 * spacing)
    height: interactiveView.height + (2 * spacing)

    radius: Appearance.defaults.rounding
    color: root.frosted ? "transparent" : Appearance.defaults.surfaceColor

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: Appearance.defaults.surfaceColor
        opacity: root.frosted ? 0.35 : 0
    }

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: "transparent"
        border.color: Qt.rgba(1, 1, 1, 0.12)
        border.width: root.frosted ? 1 : 0
    }

    Rectangle {
        id: interactiveView

        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: root.fillWidth ? undefined : parent.horizontalCenter
        anchors.left: root.fillWidth ? parent.left : undefined
        anchors.right: root.fillWidth ? parent.right : undefined
        anchors.leftMargin: root.fillWidth ? root.spacing : 0
        anchors.rightMargin: root.fillWidth ? root.spacing : 0

        width: root.fillWidth ? undefined : contentLoader.implicitWidth
        height: contentLoader.implicitHeight

        radius: Appearance.defaults.rounding
        color: root.active ? Appearance.defaults.primaryColor : root.hovered ? Appearance.defaults.primaryColor : root.frosted ? Qt.rgba(1, 1, 1, 0.15) : Appearance.defaults.surfaceColor

        Loader {
            id: contentLoader
            anchors.fill: root.fillWidth ? parent : undefined
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            preventStealing: true
            onEntered: {
                root.hovered = true;
                root.hover(true);
            }
            onExited: {
                root.hovered = false;
                root.hover(false);
            }
            onClicked: {
                if (!root.popoutManagerExempt) {
                    PopOutManager.hideCurrent();
                }
                root.clicked();
            }
        }
    }
}
