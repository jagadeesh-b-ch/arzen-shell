pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "./../../config"
import "./../../widgets"

Rectangle {
    id: root

    property string icon
    property string text
    property var cmd
    property var action
    property bool hovered: false

    implicitWidth: row.implicitWidth
    height: row.implicitHeight + 2 * Appearance.defaults.vPadding
    radius: Appearance.defaults.rounding
    color: root.hovered ? Appearance.defaults.primaryColor : "transparent"

    Row {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        spacing: Appearance.spacing.small

        Item { width: Appearance.defaults.hPadding; height: 1 }

        MaterialIcon {
            text: root.icon
            hovered: root.hovered
            active: root.hovered
            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            text: root.text
            hovered: root.hovered
            active: root.hovered
            anchors.verticalCenter: parent.verticalCenter
        }

        Item { width: Appearance.defaults.hPadding; height: 1 }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root.hovered = true
        onExited: root.hovered = false
        onClicked: {
            if (root.cmd)
                Quickshell.execDetached(root.cmd);
            if (root.action)
                root.action();
        }
    }
}
