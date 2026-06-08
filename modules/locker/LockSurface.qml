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
    property bool suppressTextChanged: false
    property bool firstMouseEvent: true

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

    Timer {
        id: idleTimer
        interval: 5000
        onTriggered: {
            root.activeState = false;
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.ArrowCursor
        onPositionChanged: {
            if (root.firstMouseEvent) {
                root.firstMouseEvent = false;
                return;
            }
            root.onInputActivity();
            if (powerMenu.visible) {
                var pos = powerMenu.mapFromItem(root, mouse.x, mouse.y);
                if (pos.x >= 0 && pos.x <= powerMenu.width && pos.y >= 0 && pos.y <= powerMenu.height) {
                    autoCloseTimer.stop();
                } else {
                    autoCloseTimer.restart();
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        visible: powerMenu.visible
        acceptedButtons: Qt.LeftButton
        onClicked: powerMenu.visible = false
    }

    Item {
        focus: !root.activeState
        Keys.onPressed: event => {
            root.onInputActivity();
            event.accepted = false;
        }
    }

    Connections {
        target: root.passwordFieldItem
        function onTextChanged() {
            if (!root.suppressTextChanged) {
                idleTimer.restart();
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

    }

    Timer {
        id: autoCloseTimer
        interval: 3000
        onTriggered: powerMenu.visible = false
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.activeState
        onActivated: root.deactivate()
    }

    function onInputActivity() {
        if (!root.activeState) {
            root.activate();
        }
        idleTimer.restart();
    }

    function activate() {
        activeState = true;
        idleTimer.restart();
        if (root.passwordFieldItem)
            root.passwordFieldItem.forceActiveFocus();
    }

    function deactivate() {
        suppressTextChanged = true;
        activeState = false;
        idleTimer.stop();
        if (root.passwordFieldItem)
            root.passwordFieldItem.text = "";
        root.context.currentText = "";
        suppressTextChanged = false;
    }
}
