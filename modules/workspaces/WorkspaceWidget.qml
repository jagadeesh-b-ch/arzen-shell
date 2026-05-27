import QtQuick
import "./../../services"
import "./../../widgets"
import "./../../config"
import QtQuick.Layouts

StyledView {
    RowLayout {
        id: workspaceLayout
        spacing: Appearance.defaults.spacing
        Repeater {
            model: Hyprland.finalWorkspaceIds
            delegate: Workspace {
                id: workspaceNumber
                required property var modelData
                workspaceId: modelData
                activeWorkspaceId: Hyprland.activeWsId
                z: 1 // Ensure text is above the background
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
