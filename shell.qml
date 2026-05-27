import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick
import "./modules"
import "./modules/background"
import "./services"

Scope {
  TopBar {}
  Background {}

  PanelWindow {
    id: dismissOverlay
    visible: PopOutManager.currentPopOut !== null
    color: "transparent"
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "archie-dismiss"

    MouseArea {
      anchors.fill: parent
      onClicked: PopOutManager.hideCurrent()
    }
  }
}

