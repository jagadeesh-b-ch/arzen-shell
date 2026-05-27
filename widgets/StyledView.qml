import QtQuick
import "./../config"

Rectangle {
    id: root
    property int spacing: Appearance.padding.smallest

    width: contentLoader.implicitWidth + (2 * spacing)
    height: contentLoader.implicitHeight + (2 * spacing)
    radius: Appearance.defaults.rounding
    color: Appearance.defaults.color.secondaryContainer

    default property alias content: contentLoader.sourceComponent

    Item {
        anchors.fill: parent
        anchors.margins: root.spacing
        Loader {
            id: contentLoader
        }
    }
}
