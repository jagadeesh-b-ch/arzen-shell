pragma ComponentBehavior: Bound

import QtQuick
import QtQml
import QtQuick.Controls
import "./../config"
import "./../widgets"

Item {
    id: root
    property bool frosted: true
    property real frostedOpacity: 0.7
    property int maxVisible: -1
    property bool fillWidth: false
    default property alias entries: container.data
    readonly property alias listContainer: container

    StyledView {
        id: bg
        z: 0
        spacing: 0
        frosted: root.frosted
        frostedOpacity: root.frostedOpacity
    }

    Binding { target: bg; property: "width"; value: root.width }
    Binding { target: bg; property: "height"; value: root.height }

    readonly property real _avgEntryHeight: container.implicitHeight / Math.max(1, container.children.length)
    readonly property real _listHeight: root.maxVisible > 0 ? Math.min(container.implicitHeight, _avgEntryHeight * root.maxVisible) : container.implicitHeight
    property real _capturedFullHeight: -1

    on_ListHeightChanged: {
        if (_capturedFullHeight < 0 && root.maxVisible > 0 && container.children.length >= root.maxVisible)
            _capturedFullHeight = _listHeight;
    }

    readonly property real _displayHeight: _capturedFullHeight > 0 ? Math.max(_listHeight, _capturedFullHeight) : _listHeight

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
        height: _displayHeight
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
    height: flick.y + _displayHeight + Appearance.defaults.vPadding
}
