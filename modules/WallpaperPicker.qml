pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./../services"
import "./../widgets"
import "./../config"

PanelWindow {
  id: root

  color: "transparent"
  visible: false
  focusable: true

  anchors.top: true
  anchors.bottom: true
  anchors.left: true
  anchors.right: true

  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.namespace: "archie-wallpaperPicker"
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  property int currentIndex: 0
  readonly property int count: carouselRepeater.count
  property bool animateCarousel: true

  Rectangle {
    anchors.fill: parent
    color: "#60000000"

    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton
      onClicked: root.close()
    }
  }

  Item {
    id: carouselBox
    x: 40
    width: root.width - 80
    height: carouselRow.height
    clip: true
    y: (root.height - height) / 2
    z: 1

    Row {
      id: carouselRow
      x: (carouselBox.width / 2) - (root.currentIndex * 160 + 240)
      spacing: 0

      Behavior on x {
        enabled: root.animateCarousel
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
      }

      Repeater {
        id: carouselRepeater
        model: Wallpapers.list

        delegate: Item {
          required property var modelData
          required property int index

          readonly property int dist: Math.abs(index - root.currentIndex)

          implicitWidth: dist === 0 ? 480 : 160
          implicitHeight: 300

          Rectangle {
            anchors.fill: parent
            color: "#222222"
            clip: true

            Image {
              anchors.fill: parent
              source: "file://" + modelData.path
              asynchronous: true
              sourceSize.width: 480
              sourceSize.height: 300
              fillMode: Image.PreserveAspectCrop
            }
          }

          MouseArea {
            anchors.fill: parent
            onClicked: {
              if (root.currentIndex === index) {
                root.setAndClose()
              } else {
                root.currentIndex = index
              }
            }
          }

          Behavior on implicitWidth {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
          }
          Behavior on implicitHeight {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
          }
        }
      }
    }
  }

  Item {
    id: keyboardHandler
    anchors.fill: parent
    focus: true
    Keys.onLeftPressed: {
      if (root.currentIndex > 0) root.currentIndex--
    }
    Keys.onRightPressed: {
      if (root.currentIndex < root.count - 1) root.currentIndex++
    }
    Keys.onReturnPressed: root.setAndClose()
    Keys.onEnterPressed: root.setAndClose()
    Keys.onEscapePressed: root.close()
  }

  IpcHandler {
    target: "wallpaperpicker"
    function open(): void { root.showPicker(null); }
  }

  function showPicker(screen) {
    var s = screen || (Quickshell.screens.length > 0 ? Quickshell.screens[0] : null)
    if (s) {
      root.screen = s
    }

    animateCarousel = false
    setCurrentIndexToActual()
    visible = true
    requestActivate()
    keyboardHandler.forceActiveFocus()
    animateCarousel = true
  }

  function setAndClose() {
    var list = Wallpapers.list
    if (count > 0 && currentIndex >= 0 && currentIndex < list.length) {
      Wallpapers.setWallpaper(list[currentIndex].path)
    }
    close()
  }

  function setCurrentIndexToActual() {
    var cur = Wallpapers.actualCurrent
    currentIndex = 0
    for (var i = 0; i < count; i++) {
      if (Wallpapers.list[i].path === cur) {
        currentIndex = i
        break
      }
    }
  }

  function close() {
    visible = false
    animateCarousel = false
    setCurrentIndexToActual()
    animateCarousel = true
  }
}
