pragma ComponentBehavior: Bound

import QtQuick 2.15
import "./../widgets"
import "./../config"

Item {
  id: root

  property var currentScreen: null
  property WallpaperPicker picker: WallpaperPicker {
    id: pickerWindow
  }

  width: styledView.width
  height: styledView.height

  StyledView {
    id: styledView
    spacing: 0
    content: InteractiveView {
      id: wallpaperButton
      popoutManagerExempt: true

      content: MaterialIconPadded {
        text: "\uE3B6"
        active: wallpaperButton.active
        hovered: wallpaperButton.hovered
      }

      onClicked: pickerWindow.showPicker(root.currentScreen)
    }
  }
}
