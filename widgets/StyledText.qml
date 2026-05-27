import QtQuick
import "./../config"

Text {
    id: styledText
    property bool active: false
    property bool hovered: false

    color: active ? Appearance.defaults.color.contentOnPrimary : hovered ? Appearance.defaults.color.contentOnSecondary : Appearance.defaults.color.contentOnSecondaryContainer
    font.family: Appearance.defaults.fontFamily
    font.pointSize: Appearance.defaults.fontSize
}
