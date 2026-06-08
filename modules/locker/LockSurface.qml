import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "./../../config"
import "./../../utils"
import "./../../widgets"
import "./../power"

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

    Rectangle {
        id: backgroundRect
        visible: root.activeState
        anchors.centerIn: parent
        width: colLayout.width + Appearance.padding.large * 2
        height: colLayout.height + Appearance.padding.large * 2
        radius: Appearance.defaults.rounding
        color: {
            var c = Appearance.defaults.color.surfaceVariant;
            return c + "CC";
        }

        ColumnLayout {
            id: colLayout
            anchors.centerIn: parent
            width: implicitWidth

            BigClock {
                Layout.alignment: Qt.AlignHCenter
            }

            LockPassword {
                id: passwordComponent
                Layout.alignment: Qt.AlignHCenter
                context: root.context
            }

            Item {
                Layout.alignment: Qt.AlignRight
                Layout.topMargin: Appearance.spacing.normal

                MaterialIconPadded {
                    id: powerBtn
                    text: "\uE8AC"
                }

                MouseArea {
                    anchors.fill: powerBtn
                    onClicked: powerMenu.visible = !powerMenu.visible
                }

                Rectangle {
                    id: powerMenu
                    visible: false
                    anchors.bottom: powerBtn.top
                    anchors.right: powerBtn.right
                    anchors.bottomMargin: Appearance.spacing.small
                    radius: Appearance.defaults.rounding
                    color: Appearance.defaults.color.surfaceVariant

                    MenuList {
                        PowerMenuEntry { icon: "restart_alt"; text: "Restart"; cmd: ["systemctl", "reboot"] }
                        PowerMenuEntry { icon: "power_off"; text: "Shutdown"; cmd: ["systemctl", "poweroff"] }
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.activeState
        onActivated: root.deactivate()
    }

    MouseArea {
        anchors.fill: parent
        visible: powerMenu.visible
        onClicked: powerMenu.visible = false
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
