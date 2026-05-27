import Qt.labs.platform
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
  id: root
  required property QtObject context
  color: "#111111"

  property bool activeState: false
  property var currentDate: new Date()

  readonly property url stateDir: `${StandardPaths.standardLocations(StandardPaths.GenericStateLocation)[0]}/archie`
  readonly property string wallpaperPathFile: `${stateDir}/wallpaper/path.txt`.slice(7)

  Loader {
    id: pathLoader
    sourceComponent: pathReader
    active: wallpaperPathFile !== ""
  }

  Component {
    id: pathReader
    FileView {
      path: root.wallpaperPathFile
      onLoaded: wallpaperImage.source = "file://" + text().trim()
    }
  }

  Image {
    id: wallpaperImage
    anchors.fill: parent
    asynchronous: true
    fillMode: Image.PreserveAspectCrop
    sourceSize.width: parent.width
    sourceSize.height: parent.height
  }

  MultiEffect {
    anchors.fill: parent
    visible: root.activeState
    source: wallpaperImage
    blurEnabled: true
    blur: 1.0
    blurMax: 64
    saturation: 0.3
    brightness: -0.15
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    cursorShape: Qt.BlankCursor
    onPositionChanged: if (!root.activeState) root.activate()
  }

  Item {
    focus: !root.activeState
    Keys.onPressed: event => {
      if (!root.activeState) {
        root.activate()
        event.accepted = false
      }
    }
  }

  ColumnLayout {
    visible: root.activeState
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.verticalCenter
    anchors.topMargin: -120
    spacing: 24

    Label {
      id: clockLabel
      Layout.alignment: Qt.AlignHCenter
      Layout.fillWidth: false
      renderType: Text.NativeRendering
      font.pointSize: 80
      color: "white"
      text: {
        var h = root.currentDate.getHours().toString().padStart(2, "0")
        var m = root.currentDate.getMinutes().toString().padStart(2, "0")
        return h + ":" + m
      }
    }

    Timer {
      running: true; repeat: true; interval: 1000
      onTriggered: root.currentDate = new Date()
    }

    Label {
      Layout.alignment: Qt.AlignHCenter
      Layout.fillWidth: false
      renderType: Text.NativeRendering
      font.pointSize: 16
      color: "#ccffffff"
      text: {
        var d = root.currentDate
        var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return days[d.getDay()] + ", " + d.getDate() + " " + months[d.getMonth()]
      }
    }

    RowLayout {
      spacing: 12
      Layout.topMargin: 20

      TextField {
        id: passwordField
        implicitWidth: 320
        padding: 14
        focus: root.activeState
        enabled: !root.context.unlockInProgress
        echoMode: TextInput.Password
        inputMethodHints: Qt.ImhSensitiveData
        placeholderText: "Password"
        color: "white"
        placeholderTextColor: "#80ffffff"

        background: Rectangle {
          color: "#33ffffff"
          radius: 10
          border.color: "#66ffffff"
          border.width: 1
        }

        onTextChanged: root.context.currentText = text
        onAccepted: root.context.tryUnlock()
        Connections {
          target: root.context
          function onCurrentTextChanged() {
            if (passwordField.text !== root.context.currentText)
              passwordField.text = root.context.currentText
          }
        }
      }

      Button {
        text: "Unlock"
        padding: 14
        focusPolicy: Qt.NoFocus
        enabled: !root.context.unlockInProgress && root.context.currentText !== ""

        background: Rectangle {
          color: parent.enabled ? "#4CAF50" : "#333333"
          radius: 10
        }
        contentItem: Text {
          text: parent.text
          color: "white"
          font.pointSize: 13
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter
        }

        onClicked: root.context.tryUnlock()
      }
    }

    Label {
      visible: root.context.showFailure
      Layout.alignment: Qt.AlignHCenter
      Layout.fillWidth: false
      text: "Incorrect password"
      color: "#ff4444"
      font.pointSize: 14
    }

    Label {
      visible: root.context.showError
      Layout.alignment: Qt.AlignHCenter
      Layout.fillWidth: false
      text: root.context.errorMessage
      color: "#ff4444"
      font.pointSize: 14
    }
  }

  Shortcut {
    sequence: "Escape"
    enabled: root.activeState
    onActivated: root.deactivate()
  }

  function activate() {
    activeState = true
    passwordField.forceActiveFocus()
  }

  function deactivate() {
    activeState = false
    passwordField.text = ""
    root.context.currentText = ""
  }
}
