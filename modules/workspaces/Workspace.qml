pragma ComponentBehavior: Bound

import QtQuick
import "./../../widgets"
import "./../../services"

Item {
    id: workspaceItem

    property int workspaceId
    property int activeWorkspaceId

    implicitWidth: workspaceComponent.width
    implicitHeight: workspaceComponent.height

    InteractiveView {
        id: workspaceComponent
        StyledTextPadded {
            text: workspaceItem.workspaceId
            active: workspaceComponent.active
            hovered: workspaceComponent.hovered
        }
        active: workspaceItem.workspaceId == workspaceItem.activeWorkspaceId
        onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${workspaceItem.workspaceId} })`)
    }
}
