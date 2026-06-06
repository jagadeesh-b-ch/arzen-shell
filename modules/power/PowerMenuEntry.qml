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

    property bool _hovered: false

    implicitWidth: textMetrics.width + iconMetrics.width + Appearance.spacing.small + 2 * Appearance.defaults.hPadding
    height: row.implicitHeight + 2 * Appearance.defaults.vPadding
    radius: Appearance.defaults.rounding
    color: _hovered ? Appearance.defaults.surfaceColor : "transparent"

    TextMetrics {
        id: textMetrics
        font.family: Appearance.defaults.fontFamily
        font.pointSize: Appearance.defaults.fontSize
        text: root.text
    }

    TextMetrics {
        id: iconMetrics
        font.family: Appearance.fontFamily.material
        font.pointSize: Appearance.defaults.fontSize
        text: root.icon
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: Appearance.spacing.small

        Item { width: Appearance.defaults.hPadding; height: 1 }

        MaterialIcon {
            text: root.icon
            hovered: root._hovered
            active: false
            anchors.verticalCenter: parent.verticalCenter
        }

        StyledText {
            text: root.text
            hovered: root._hovered
            active: false
            anchors.verticalCenter: parent.verticalCenter
        }

        Item { width: Appearance.defaults.hPadding; height: 1 }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: root._hovered = true
        onExited: root._hovered = false
        onClicked: {
            if (root.cmd)
                Quickshell.execDetached(root.cmd);
            if (root.action)
                root.action();
        }
    }
}
