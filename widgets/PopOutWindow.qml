import QtQuick
import QtQuick.Window
import Quickshell
import "./../config"
import "./../services"
import "./../widgets"

PopupWindow {
    id: popOutWindow

    property Item anchorTarget: parent
    property int hostWidth: 10
    property int hostHeight: 3
    property int hPadding: Appearance.defaults.hPadding
    property int vPadding: Appearance.defaults.vPadding

    color: "transparent"

    anchor.item: anchorTarget
    anchor.rect.x: -((implicitWidth - hostWidth) / 2 + hPadding)
    anchor.rect.y: hostHeight + (2 * vPadding)

    onClosed: PopOutManager.hide(popOutWindow)
    onVisibleChanged: {
        if (!visible) {
            outsideTimer.stop();
            PopOutManager.hide(popOutWindow);
        } else {
            initCheckTimer.start();
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: PopOutManager.hide(popOutWindow)
    }

    Timer {
        id: outsideTimer
        interval: 1000
        onTriggered: PopOutManager.hide(popOutWindow)
    }

    Timer {
        id: initCheckTimer
        interval: 0
        onTriggered: {
            if (visible && !hoverTracker.hovered)
                outsideTimer.start();
        }
    }

    HoverHandler {
        id: hoverTracker
        target: popOutView
        onHoveredChanged: {
            if (hoverTracker.hovered)
                outsideTimer.stop();
            else if (visible)
                outsideTimer.restart();
        }
    }

    StyledView {
        id: popOutView
        anchors.fill: parent
        spacing: 0
    }

    function show() {
        visible = true;
    }

    function forceHide() {
        visible = false;
    }

    function restartAutoHide() {
        forceHide();
    }
}
