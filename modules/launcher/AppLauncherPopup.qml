import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./../../config"
import "./../../services"
import "./../../utils"
import "./../../widgets"

PanelWindow {
    id: popup

    property int popupWidth: Screen.width / 2
    property int popupHeight: Screen.height / 2
    property int selectedIndex: 0
    property var filteredApps: []

    color: "transparent"
    visible: false
    focusable: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "archie-launcher"
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    IpcHandler {
        target: "launcher"
        function open(): void {
            PopOutManager.hideCurrent();
            popup.show();
        }
        function close(): void {
            popup.forceHide();
        }
    }

    ListModel {
        id: appModel
    }

    Connections {
        target: Applications
        function onAppsReadyChanged() {
            if (visible && Applications.appsReady)
                populateModel(searchInput.text);
        }
    }

    onVisibleChanged: {
        if (!visible)
            searchInput.text = "";
    }

    function show() {
        searchInput.text = "";
        selectedIndex = 0;
        visible = true;
        if (Applications.appsReady)
            populateModel("");
        Qt.callLater(function () {
            searchInput.forceActiveFocus();
        });
    }

    function forceHide() {
        visible = false;
    }

    Shortcut {
        sequence: "Escape"
        onActivated: popup.visible = false
    }

    function populateModel(query) {
        appModel.clear();
        filteredApps = Applications.filterApps(query);
        for (var i = 0; i < filteredApps.length; i++)
            appModel.append({ entry: filteredApps[i] });
        if (selectedIndex >= appModel.count)
            selectedIndex = Math.max(0, appModel.count - 1);
    }

    function launchSelected() {
        if (selectedIndex >= 0 && selectedIndex < appModel.count) {
            var app = appModel.get(selectedIndex).entry;
            Applications.launch(app);
        }
        popup.visible = false;
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var pt = mapToItem(popupContent, mouse.x, mouse.y);
            if (pt.x < 0 || pt.x > popupContent.width || pt.y < 0 || pt.y > popupContent.height)
                popup.visible = false;
        }
    }

    Rectangle {
        id: popupContent
        width: popupWidth
        height: popupHeight
        anchors.centerIn: parent
        radius: Appearance.defaults.rounding
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Appearance.defaults.backgroundColor
            opacity: 0.35
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: Qt.rgba(1, 1, 1, 0.12)
            border.width: 1
        }

        Column {
            anchors.fill: parent
            anchors.margins: Appearance.padding.normal
            spacing: Appearance.spacing.small

            StyledTextField {
                id: searchInput
                width: parent.width
                pointSize: Appearance.fontSize.larger
                surfaceBackground: Appearance.defaults.color.secondaryContainer
                color: Appearance.defaults.color.contentOnSecondaryContainer
                selectByMouse: true

                Keys.onPressed: function (event) {
                    if ((event.key === Qt.Key_J && (event.modifiers & Qt.ControlModifier)) || event.key === Qt.Key_Down) {
                        if (selectedIndex < appModel.count - 1) {
                            selectedIndex++;
                            listView.positionViewAtIndex(selectedIndex, ListView.Contain);
                        }
                        event.accepted = true;
                    } else if ((event.key === Qt.Key_K && (event.modifiers & Qt.ControlModifier)) || event.key === Qt.Key_Up) {
                        if (selectedIndex > 0) {
                            selectedIndex--;
                            listView.positionViewAtIndex(selectedIndex, ListView.Contain);
                        }
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        launchSelected();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Escape) {
                        popup.visible = false;
                        event.accepted = true;
                    }
                }

                onTextChanged: {
                    selectedIndex = 0;
                    populateModel(text);
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Appearance.defaults.color.outline
            }

            ListView {
                id: listView
                width: parent.width
                height: parent.height - searchInput.height - 1 - Appearance.spacing.small
                clip: true
                model: appModel
                boundsBehavior: Flickable.StopAtBounds

                delegate: AppEntry {
                    width: listView.width
                    entry: model.entry
                    isSelected: index === selectedIndex
                    onClicked: {
                        selectedIndex = index;
                        launchSelected();
                    }
                }
            }
        }
    }
}
