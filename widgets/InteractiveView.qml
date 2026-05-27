import QtQuick
import "./../config"
import "./../services"

Rectangle {
    id: root

    property int spacing: 0
    property bool active: false
    property bool hovered: false
    property bool popoutManagerExempt: false
    signal clicked
    signal hover(bool hovered)
    default property alias content: contentLoader.sourceComponent

    width: interactiveView.width + (2 * spacing)
    height: interactiveView.height + (2 * spacing)

    radius: Appearance.defaults.rounding
    color: Appearance.defaults.color.secondaryContainer

    Rectangle {
        id: interactiveView

        anchors.centerIn: parent

        width: contentLoader.implicitWidth
        height: contentLoader.implicitHeight
        anchors.margins: Appearance.padding.smallest

        radius: Appearance.defaults.rounding
        color: root.active ? Appearance.defaults.color.primary : root.hovered ? Appearance.defaults.color.secondary : Appearance.defaults.color.secondaryContainer

        Loader {
            id: contentLoader
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
                root.clicked()
            }
        }
    }
}
