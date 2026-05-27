import Quickshell
import QtQuick
import "./../widgets"
import "./../config"
import "./../services"

Scope {
    Variants {
        model: Quickshell.screens

        StyledWindow {
            id: topBar
            property var modelData
            name: "topBar"
            screen: modelData

            anchors.top: true
            anchors.left: true
            anchors.right: true

            implicitHeight: Math.max(leftModules.implicitHeight, rightModules.implicitHeight) + (2 * Appearance.defaults.vPadding)

            Item {
                id: topBarContainer
                anchors.fill: parent
                anchors.leftMargin: Appearance.defaults.hPadding
                anchors.rightMargin: Appearance.defaults.hPadding
                anchors.topMargin: Appearance.defaults.vPadding
                anchors.bottomMargin: Appearance.defaults.vPadding

                MouseArea {
                    z: -1
                    anchors.fill: parent
                    onClicked: PopOutManager.hideCurrent()
                }

                LeftModules {
                    id: leftModules
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                RightModules {
                    id: rightModules
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    currentScreen: topBar.screen
                }

                Connections {
                    target: Hyprland
                    function onWindowFocusChanged() {
                        PopOutManager.hideCurrent();
                    }
                }
            }
        }
    }
}
