import QtQuick 2.15
import "./../../config"
import "./../../services"
import "./../../utils"
import "./../../widgets"

Item {
    width: launcherView.width
    height: launcherView.height

    AppLauncherPopup {
        id: launcherPopup
    }

    InteractiveView {
        id: launcherView
        spacing: Appearance.padding.smallest
        popoutManagerExempt: true
        onClicked: {
            if (PopOutManager.currentPopOut === launcherPopup)
                PopOutManager.hide(launcherPopup);
            else
                PopOutManager.show(launcherPopup);
        }

        content: StyledTextPadded {
            text: Icons.osIcon
            active: launcherView.active
            hovered: launcherView.hovered
        }
    }
}
