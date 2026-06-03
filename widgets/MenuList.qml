pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import "./../config"

StyledView {
    id: root
    spacing: 0

    property list<QtObject> model: []
    property int fontPointSize: Appearance.defaults.fontSize
    property int itemSpacing: Appearance.spacing.small

    Column {
        spacing: Appearance.padding.smallest

        TextMetrics {
            id: textMetrics
            font.family: Appearance.defaults.fontFamily
        }

        TextMetrics {
            id: iconMetrics
            font.family: Appearance.fontFamily.material
        }

        Repeater {
            model: root.model

            delegate: InteractiveView {
                id: delegateRoot
                required property QtObject modelData
                spacing: Appearance.padding.small

                content: Column {
                    Item { height: Appearance.padding.small; width: 1 }

                    Row {
                        spacing: root.itemSpacing

                        Item { width: Appearance.defaults.hPadding; height: 1 }

                        MaterialIcon {
                            id: iconItem
                            text: delegateRoot.modelData.icon
                            font.pointSize: root.fontPointSize
                            hovered: delegateRoot.hovered
                            active: delegateRoot.active
                        }

                        StyledText {
                            id: textItem
                            text: delegateRoot.modelData.text
                            font.pointSize: root.fontPointSize
                            hovered: delegateRoot.hovered
                            active: delegateRoot.active
                        }

                        Item { width: Appearance.defaults.hPadding; height: 1 }
                    }

                    Item { height: Appearance.padding.small; width: 1 }
                }

                onClicked: {
                    if (delegateRoot.modelData.cmd)
                        Quickshell.execDetached(delegateRoot.modelData.cmd);
                    if (delegateRoot.modelData.action)
                        delegateRoot.modelData.action();
                }
            }
        }
    }
}
