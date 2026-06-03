import QtQuick
import "./../config"

Text {
    id: styledText
    property bool active: false
    property bool hovered: false

    color: active ? Appearance.defaults.contentOnPrimaryColor : hovered ? Appearance.defaults.contentOnPrimaryColor : Appearance.defaults.contentOnSurfaceColor
    font.family: Appearance.defaults.fontFamily
    font.pointSize: Appearance.defaults.fontSize
}
