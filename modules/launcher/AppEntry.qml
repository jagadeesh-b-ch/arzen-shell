pragma ComponentBehavior: Bound

import QtQuick
import "./../../config"
import "./../../utils"
import "./../../widgets"

InteractiveView {
    id: root

    property var entry: null
    property bool isSelected: false
    readonly property int entryPadding: Appearance.padding.normal

    fillWidth: true
    active: isSelected

    content: Item {
        id: contentItem

        readonly property real entryHeight: detailsColumn.height

        implicitHeight: entryHeight + root.entryPadding * 2

        Row {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: root.entryPadding
            anchors.rightMargin: root.entryPadding
            anchors.verticalCenter: parent.verticalCenter
            spacing: Appearance.padding.small

            Item {
                id: iconContainer
                width: contentItem.entryHeight
                height: contentItem.entryHeight
                clip: true

                Image {
                    anchors.fill: parent
                    anchors.margins: Appearance.padding.smallest
                    fillMode: Image.PreserveAspectFit
                    source: root.entry.icon ? (root.entry.icon.charAt(0) === "/" ? "file://" + root.entry.icon : "image://icon/" + root.entry.icon) : ("image://icon/" + (Icons.categoryIcons[root.entry.categories?.[0]] || "application-x-executable"))
                    sourceSize.width: iconContainer.width - Appearance.padding.smallest * 2
                    sourceSize.height: iconContainer.height - Appearance.padding.smallest * 2
                    asynchronous: true
                }
            }

            Column {
                id: detailsColumn
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2

                StyledText {
                    text: root.entry.name
                    font.pixelSize: Appearance.fontSize.larger
                    active: root.active
                    hovered: root.hovered
                }

                StyledText {
                    id: descText
                    text: root.entry.genericName || root.entry.comment || " "
                    font.pixelSize: Appearance.fontSize.normal
                    active: root.active
                    hovered: root.hovered
                    opacity: root.entry.genericName || root.entry.comment ? 0.7 : 0
                }
            }
        }
    }
}
