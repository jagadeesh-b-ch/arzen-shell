pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import "./../config"

Rectangle {
    id: root
    property bool frosted: true
    property int maxVisible: -1
    property bool fillWidth: false
    default property alias entries: container.data
    readonly property alias listContainer: container

    radius: Appearance.defaults.rounding
    color: root.frosted ? "transparent" : Appearance.defaults.surfaceColor

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

    readonly property real _avgEntryHeight: container.implicitHeight / Math.max(1, container.children.length)
    readonly property real _listHeight: root.maxVisible > 0 ? Math.min(container.implicitHeight, _avgEntryHeight * root.maxVisible) : container.implicitHeight

    function ensureVisible(index: int): void {
        var child = container.children[index];
        if (!child) return;
        var itemTop = child.y;
        var itemBottom = itemTop + child.height;
        if (itemTop < flick.contentY)
            flick.contentY = itemTop;
        else if (itemBottom > flick.contentY + flick.height)
            flick.contentY = itemBottom - flick.height;
    }

    Flickable {
        id: flick
        x: Appearance.defaults.hPadding
        y: Appearance.defaults.vPadding
        width: root.fillWidth ? root.width - 2 * Appearance.defaults.hPadding : container.width
        height: _listHeight
        contentWidth: container.width
        contentHeight: container.implicitHeight
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
        }

        Column {
            id: container
            spacing: Appearance.padding.smallest

            onChildrenChanged: Qt.callLater(adjustWidths)
            Component.onCompleted: Qt.callLater(adjustWidths)

            function adjustWidths() {
                var children = container.children;
                var maxW = 0;
                var i;
                for (i = 0; i < children.length; i++) {
                    var w = children[i].implicitWidth;
                    if (w > maxW) maxW = w;
                }
                if (root.fillWidth && flick.width > maxW)
                    container.width = flick.width;
                else
                    container.width = maxW;
                for (i = 0; i < children.length; i++)
                    children[i].width = container.width;
            }
        }
    }

    width: root.fillWidth && parent ? Math.max(container.width + 2 * Appearance.defaults.hPadding, parent.width) : container.width + 2 * Appearance.defaults.hPadding
    height: flick.y + _listHeight + Appearance.defaults.vPadding
}
