import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Io
import "./../../config"
import "./../../utils"
import "./../../widgets"

Rectangle {
    id: root
    required property QtObject context
    color: "transparent"

    property bool activeState: false

    readonly property string wallpaperPathFile: `${Paths.state}/wallpaper/path.txt`.slice(7)

    Image {
        id: wallpaperImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        opacity: status === Image.Ready ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.OutExpo } }
    }

    Loader {
        sourceComponent: pathReader
        active: root.wallpaperPathFile !== ""
    }

    Component {
        id: pathReader
        FileView {
            path: root.wallpaperPathFile
            onLoaded: wallpaperImage.source = "file://" + text().trim()
        }
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
        onPositionChanged: if (!root.activeState)
            root.activate()
    }

    Item {
        focus: !root.activeState
        Keys.onPressed: event => {
            if (!root.activeState) {
                root.activate();
                event.accepted = false;
            }
        }
    }

    ColumnLayout {
        visible: root.activeState
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        BigClock {
            Layout.alignment: Qt.AlignHCenter
        }

        LockPassword {
            id: passwordComponent
            Layout.alignment: Qt.AlignHCenter
            context: root.context
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.activeState
        onActivated: root.deactivate()
    }

    function activate() {
        activeState = true;
        passwordComponent.passwordField.forceActiveFocus();
    }

    function deactivate() {
        activeState = false;
        passwordComponent.passwordField.text = "";
        root.context.currentText = "";
    }
}
