import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "./../../config"
import "./../../services"
import Quickshell.Hyprland
import "./../../utils"
import "./../../widgets"

PanelWindow {
    id: popup

    property int popupWidth: Screen.width / 2
    property int popupHeight: Screen.height / 2
    property int selectedIndex: 0
    property var historyData: ({})
    property bool appsReady: false

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

    Timer {
        id: retryTimer
        interval: 200
        repeat: true
        onTriggered: {
            if (DesktopEntries.applications.values.length > 0) {
                appsReady = true;
                retryTimer.stop();
                if (visible)
                    populateModel(searchInput.text);
            }
        }
    }

    onVisibleChanged: {
        if (!visible) {
            searchInput.text = "";
            retryTimer.stop();
        }
    }

    function show() {
        searchInput.text = "";
        selectedIndex = 0;
        visible = true;
        if (DesktopEntries.applications.values.length > 0) {
            appsReady = true;
            populateModel("");
        } else {
            retryTimer.start();
        }
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
        var q = query.trim().toLowerCase();
        try {
            var apps = DesktopEntries.applications.values;
            if (!apps || apps.length === 0)
                return;
            appsReady = true;
            var filtered = [];
            for (var i = 0; i < apps.length; i++) {
                var app = apps[i];
                if (app.noDisplay)
                    continue;
                if (q === "" || app.name.toLowerCase().includes(q) || (app.genericName && app.genericName.toLowerCase().includes(q))) {
                    filtered.push(app);
                }
            }
            filtered.sort(function (a, b) {
                var ha = historyData[a.name];
                var hb = historyData[b.name];
                var sa = ha ? 1 : 0;
                var sb = hb ? 1 : 0;
                if (sa !== sb)
                    return sb - sa;
                if (sa && sb) {
                    if (ha.count !== hb.count)
                        return hb.count - ha.count;
                    if (ha.lastUsed !== hb.lastUsed)
                        return hb.lastUsed - ha.lastUsed;
                }
                return a.name.localeCompare(b.name);
            });
            for (var j = 0; j < filtered.length; j++)
                appModel.append({
                    entry: filtered[j]
                });
        } catch (e) {
            console.log("Launcher: ERROR in populateModel: " + e);
        }
        if (selectedIndex >= appModel.count)
            selectedIndex = Math.max(0, appModel.count - 1);
    }

    function launchSelected() {
        if (selectedIndex >= 0 && selectedIndex < appModel.count) {
            var app = appModel.get(selectedIndex).entry;
            var now = Math.floor(Date.now() / 1000);
            var entry = historyData[app.name];
            if (entry) {
                entry.count++;
                entry.lastUsed = now;
            } else {
                historyData[app.name] = {
                    count: 1,
                    lastUsed: now
                };
            }
            // Launch app on current workspace
            var command = app.exec;
            if (Hyprland.activeWsId > 0) {
                Hyprland.dispatch("exec workspace " + Hyprland.activeWsId + " " + command);
            } else {
                app.execute();
            }
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
        color: Appearance.defaults.color.secondaryContainer
        border.width: 1
        border.color: Appearance.defaults.color.outline

        Column {
            anchors.fill: parent
            anchors.margins: Appearance.padding.normal
            spacing: Appearance.spacing.small

            Rectangle {
                id: searchBox
                width: parent.width
                height: 42
                radius: Appearance.defaults.rounding
                color: Appearance.defaults.color.secondaryContainer

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.leftMargin: Appearance.padding.normal
                    anchors.rightMargin: Appearance.padding.normal
                    verticalAlignment: TextInput.AlignVCenter
                    font.family: Appearance.defaults.fontFamily
                    font.pointSize: Appearance.fontSize.larger
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
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Appearance.defaults.color.outline
            }

            ListView {
                id: listView
                width: parent.width
                height: parent.height - searchBox.height - 1 - Appearance.spacing.small
                clip: true
                model: appModel
                boundsBehavior: Flickable.StopAtBounds

                delegate: Rectangle {
                    readonly property bool isHighlighted: index === selectedIndex

                    width: listView.width
                    height: 56
                    radius: Appearance.defaults.rounding * 0.5
                    color: isHighlighted ? Appearance.defaults.color.primary : Appearance.defaults.color.secondaryContainer

                    Row {
                        anchors.fill: parent
                        anchors.margins: Appearance.padding.small
                        spacing: Appearance.spacing.small

                        Rectangle {
                            width: 36
                            height: 36
                            radius: Appearance.defaults.rounding * 0.5
                            color: isHighlighted ? Appearance.defaults.color.primary : Appearance.defaults.color.surface
                            anchors.verticalCenter: parent.verticalCenter
                            clip: true

                            Image {
                                id: appIcon
                                anchors.fill: parent
                                anchors.margins: 4
                                fillMode: Image.PreserveAspectFit
                                source: entry.icon ? (entry.icon.charAt(0) === "/" ? "file://" + entry.icon : "image://icon/" + entry.icon) : ""
                                sourceSize.width: 28
                                sourceSize.height: 28
                                asynchronous: true
                                visible: status === Image.Ready

                                onStatusChanged: {
                                    if (status === Image.Error)
                                        fallbackIcon.visible = true;
                                }
                            }

                            StyledText {
                                id: fallbackIcon
                                anchors.centerIn: parent
                                text: Icons.categoryIcons[entry.categories?.[0]] || "apps"
                                font.pixelSize: Appearance.fontSize.larger
                                color: isHighlighted ? Appearance.defaults.color.contentOnPrimary : Appearance.defaults.color.contentOnSecondaryContainer
                                visible: false
                            }
                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 2

                            StyledText {
                                text: entry.name
                                font.pixelSize: Appearance.fontSize.larger
                                color: isHighlighted ? Appearance.defaults.color.contentOnPrimary : Appearance.defaults.color.contentOnSecondaryContainer
                            }

                            StyledText {
                                text: entry.genericName || entry.comment || ""
                                font.pixelSize: Appearance.fontSize.normal
                                color: isHighlighted ? Appearance.defaults.color.contentOnPrimary : Appearance.defaults.color.contentOnSecondaryContainer
                                visible: text !== ""
                                opacity: 0.7
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            selectedIndex = index;
                            launchSelected();
                        }
                    }
                }
            }
        }
    }
}
