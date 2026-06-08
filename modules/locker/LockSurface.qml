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
    property QtObject passwordFieldItem: null
    property Item powerIconItem: null

    Binding {
        target: root
        property: "powerIconItem"
        value: {
            var col = backgroundRect.contentItem;
            if (!col) return null;
            return col.children[col.children.length - 1];
        }
    }

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
        cursorShape: Qt.ArrowCursor
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

    Item {
        id: popupGroup
        visible: root.activeState
        anchors.centerIn: parent
        width: backgroundRect.width
        height: backgroundRect.height

        StyledView {
            id: backgroundRect
            anchors.top: parent.top
            anchors.left: parent.left
            spacing: Appearance.padding.large

            ColumnLayout {
                id: colLayout
                width: implicitWidth

                BigClock {
                    Layout.alignment: Qt.AlignHCenter
                }

                LockPassword {
                    id: passwordComponent
                    Layout.alignment: Qt.AlignHCenter
                    context: root.context
                    Component.onCompleted: root.passwordFieldItem = passwordField
                }

                InteractiveView {
                    id: powerIcon
                    Layout.alignment: Qt.AlignRight
                    Layout.topMargin: Appearance.spacing.normal
                    popoutManagerExempt: true

                    MaterialIconPadded {
                        text: "\uE8AC"
                        active: powerIcon.active
                        hovered: powerIcon.hovered
                        font.pointSize: Appearance.fontSize.large
                    }

                    onClicked: powerMenu.visible = !powerMenu.visible
                }
            }
        }

        Rectangle {
            id: powerMenu
            visible: false
            anchors.top: backgroundRect.bottom
            anchors.topMargin: Appearance.spacing.small
            width: menuList.width
            height: menuList.height
            radius: Appearance.defaults.rounding
            color: Appearance.defaults.color.surfaceVariant

            MenuList {
                id: menuList
                PowerMenuEntry { icon: "restart_alt"; text: "Restart"; cmd: ["systemctl", "reboot"] }
                PowerMenuEntry { icon: "power_off"; text: "Shutdown"; cmd: ["systemctl", "poweroff"] }
            }

            Binding {
                target: powerMenu
                property: "x"
                value: {
                    var icon = root.powerIconItem;
                    if (!icon) return 0;
                    var pt = icon.mapToItem(popupGroup, icon.width / 2, 0);
                    return pt.x - powerMenu.width / 2;
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            visible: powerMenu.visible
            onClicked: powerMenu.visible = false
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.activeState
        onActivated: root.deactivate()
    }

    function activate() {
        activeState = true;
        if (root.passwordFieldItem)
            root.passwordFieldItem.forceActiveFocus();
    }

    function deactivate() {
        activeState = false;
        if (root.passwordFieldItem)
            root.passwordFieldItem.text = "";
        root.context.currentText = "";
    }
}
