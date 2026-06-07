import QtQuick
import "./../config"
import "./../services"

Rectangle {
    id: root

    property int spacing: 0
    property bool active: false
    property bool hovered: false
    property bool ignoreHover: false
    property bool popoutManagerExempt: false
    property bool fillWidth: false
    signal clicked
    signal hover(bool hovered)
    default property alias content: contentLoader.sourceComponent

    width: contentLoader.implicitWidth + (2 * spacing)
    height: contentLoader.implicitHeight + (2 * spacing)
    radius: Appearance.defaults.rounding
    color: root.active ? Appearance.defaults.primaryColor : (!root.ignoreHover && root.hovered) ? Appearance.defaults.primaryColor : "transparent"

    Item {
        anchors.fill: parent
        anchors.margins: root.spacing

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
