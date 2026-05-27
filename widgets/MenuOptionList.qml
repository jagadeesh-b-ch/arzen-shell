pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "./../config"

Column {
    id: root

    property list<QtObject> model: []

    spacing: Appearance.padding.smallest

    property real _maxEntryWidth: 0

    TextMetrics {
        id: entryMetrics
    }

    onModelChanged: recalculateMaxWidth()
    Component.onCompleted: recalculateMaxWidth()

    function recalculateMaxWidth() {
        var maxW = 0;
        for (var i = 0; i < model.length; i++) {
            var entry = model[i];
            entryMetrics.font.family = Appearance.defaults.fontFamily;
            entryMetrics.font.pointSize = Appearance.defaults.fontSize;
            entryMetrics.text = entry.text;

            var textW = entryMetrics.width;
            entryMetrics.font.family = Appearance.fontFamily.material;
            entryMetrics.text = entry.icon;

            var iconW = entryMetrics.width;
            maxW = Math.max(maxW, iconW + Appearance.spacing.small + textW);
        }
        _maxEntryWidth = maxW + 2 * Appearance.defaults.hPadding;
    }

    Repeater {
        model: root.model

        delegate: Rectangle {
            required property QtObject modelData
            property bool _hovered: false

            width: root._maxEntryWidth
            height: optionRow.implicitHeight + 2 * Appearance.defaults.vPadding
            radius: Appearance.defaults.rounding
            color: _hovered ? Appearance.defaults.color.secondary : "transparent"

            Row {
                id: optionRow
                anchors.left: parent.left
                anchors.leftMargin: Appearance.defaults.hPadding
                anchors.verticalCenter: parent.verticalCenter
                spacing: Appearance.spacing.small

                    MaterialIcon {
                        text: modelData.icon
                        hovered: parent.parent._hovered
                        active: false
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    StyledText {
                        text: modelData.text
                        hovered: parent.parent._hovered
                        active: false
                        anchors.verticalCenter: parent.verticalCenter
                    }
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        parent._hovered = true;
                    }
                    onExited: {
                        parent._hovered = false;
                    }
                onClicked: {
                    if (modelData.cmd)
                        Quickshell.execDetached(modelData.cmd);
                    if (modelData.action)
                        modelData.action();
                }
            }
        }
    }
}
