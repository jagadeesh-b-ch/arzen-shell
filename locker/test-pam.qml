import QtQuick
import Quickshell
import Quickshell.Services.Pam

FloatingWindow {
  id: testWin
  implicitWidth: 500
  implicitHeight: 300
  visible: true
  title: "PAM Auth Test"

  property string currentText: ""
  property bool unlockInProgress: false

  Column {
    anchors.centerIn: parent
    spacing: 12

    Text { text: "Enter your password to test PAM auth:" }

    TextField {
      id: pwField
      implicitWidth: 300
      echoMode: TextInput.Password
      onAccepted: tryAuth()
    }

    Button {
      text: "Test Auth"
      onClicked: tryAuth()
    }

    Text {
      id: resultText
      color: "red"
    }

    Rectangle { height: 1; width: 400; color: "#ccc" }

    Text { text: "PAM config used: locker/pam/password.conf"; font.pointSize: 10; color: "gray" }
    Text {
      text: pam.configDirectory + " / " + pam.config
      font.pointSize: 10; color: "gray"
    }

    Item { width: 1; height: 20 }

    Button {
      text: "Test REAL locker (with 30s safety timeout)"
      onClicked: {
        var locker = Qt.createQmlObject('
          import Quickshell
          import Quickshell.Wayland
          ShellRoot {
            Timer { running: true; repeat: false; interval: 30000; onTriggered: Qt.quit() }
            LockContext {
              onUnlocked: Qt.quit()
            }
            WlSessionLock {
              id: lock; locked: true
              WlSessionLockSurface {
                LockSurface { anchors.fill: parent; context: lockContext }
              }
            }
          }
        ', testWin, "reallocktest");
      }
    }
  }

  PamContext {
    id: pam
    configDirectory: "pam"
    config: "password.conf"
    onPamMessage: {
      if (responseRequired)
        respond(pwField.text)
    }
    onCompleted: result => {
      unlockInProgress = false
      if (result == PamResult.Success)
        resultText.text = "AUTH OK"
      else
        resultText.text = "AUTH FAILED"
    }
  }

  function tryAuth() {
    if (pwField.text === "") return
    resultText.text = "Testing..."
    unlockInProgress = true
    pam.start()
  }
}
