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
    property int selectedIndex: 0
    property bool keyboardActive: false
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

    Item {
        anchors.fill: parent
        opacity: 0.3

        Rectangle {
            anchors.fill: parent
            color: Appearance.defaults.backgroundColor
            opacity: Appearance.defaults.frostedOpacity
        }
    }

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

    Component {
        id: appEntryComponent
        AppEntry {}
    }

    Connections {
        target: Applications
        function onAppsReadyChanged() {
            if (visible && Applications.appsReady)
                populateMenu(popupContent.contentItem.textInput.text);
        }
    }

    onVisibleChanged: {
        if (!visible)
            popupContent.contentItem.textInput.text = "";
    }

    function show() {
        popupContent.contentItem.textInput.text = "";
        selectedIndex = 0;
        keyboardActive = true;
        visible = true;
        if (Applications.appsReady)
            populateMenu("");
        Qt.callLater(function () {
            popupContent.contentItem.textInput.forceActiveFocus();
        });
    }

    function forceHide() {
        visible = false;
    }

    Shortcut {
        sequence: "Escape"
        onActivated: popup.visible = false
    }

    function populateMenu(query) {
        var menu = popupContent.contentItem.menuList;
        var i;
        for (i = menu.entries.length - 1; i >= 0; i--)
            menu.entries[i].destroy();

        filteredApps = Applications.filterApps(query);
        for (i = 0; i < filteredApps.length; i++) {
            var entry = appEntryComponent.createObject(menu.listContainer, {
                entry: filteredApps[i],
                isSelected: i === selectedIndex,
                ignoreHover: keyboardActive
            });
            if (entry) {
                (function(entry, idx) {
                    entry.hover.connect(function(hovered) {
                        if (hovered) {
                            keyboardActive = false;
                            selectedIndex = idx;
                            updateSelection();
                        }
                    });
                    entry.clicked.connect(function() {
                        selectedIndex = idx;
                        launchSelected();
                    });
                })(entry, i);
            }
        }
        if (selectedIndex >= filteredApps.length)
            selectedIndex = Math.max(0, filteredApps.length - 1);
    }

    function launchSelected() {
        if (selectedIndex >= 0 && selectedIndex < filteredApps.length)
            Applications.launch(filteredApps[selectedIndex]);
        popup.visible = false;
    }

    function updateSelection() {
        var menu = popupContent.contentItem.menuList;
        var children = menu.entries;
        for (var i = 0; i < children.length; i++) {
            children[i].isSelected = i === selectedIndex;
            children[i].ignoreHover = keyboardActive;
        }
        menu.ensureVisible(selectedIndex);
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var pt = mapToItem(popupContent, mouse.x, mouse.y);
            if (pt.x < 0 || pt.x > popupContent.width || pt.y < 0 || pt.y > popupContent.height)
                popup.visible = false;
        }
    }

    StyledView {
        id: popupContent
        width: popupWidth
        anchors.centerIn: parent
        spacing: Appearance.padding.normal
        fillWidth: true
        backgroundVisible: false
        frostedOpacity: 0.9
        border.color: Appearance.defaults.color.outline
        border.width: 1

        Column {
            id: popupColumn
            property alias textInput: searchInput
            property alias menuList: appMenuList

            width: parent.width
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
                        if (selectedIndex < filteredApps.length - 1) {
                            selectedIndex++;
                            keyboardActive = true;
                            updateSelection();
                        }
                        event.accepted = true;
                    } else if ((event.key === Qt.Key_K && (event.modifiers & Qt.ControlModifier)) || event.key === Qt.Key_Up) {
                        if (selectedIndex > 0) {
                            selectedIndex--;
                            keyboardActive = true;
                            updateSelection();
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
                    keyboardActive = true;
                    populateMenu(text);
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Appearance.defaults.color.outline
            }

            MenuList {
                id: appMenuList
                maxVisible: 5
                fillWidth: true
                frostedOpacity: 1.0
            }
        }
    }
}
