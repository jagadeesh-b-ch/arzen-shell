import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Fusion
import "./../config"

TextField {
    id: root

    property int pointSize: Appearance.defaults.fontSize
    property int displayLength: 32
    property real letterSpacing: 0

    font.family: Appearance.defaults.fontFamily
    font.pointSize: pointSize
    font.letterSpacing: letterSpacing

    maximumLength: displayLength

    padding: Appearance.padding.large
    implicitWidth: {
        var txt = "";
        for (var i = 0; i < displayLength; i++) txt += "W";
        return fontMetrics.advanceWidth(txt) + padding * 2;
    }
    implicitHeight: fontMetrics.height + padding * 2

    color: Appearance.defaults.color.contentOnSurface
    placeholderTextColor: Appearance.defaults.color.outline

    background: Rectangle {
        color: Appearance.defaults.color.surface
        radius: Appearance.defaults.rounding
        border.color: root.activeFocus ? Appearance.defaults.color.primary : Appearance.defaults.color.outline
        border.width: 1
    }

    FontMetrics {
        id: fontMetrics
        font: root.font
    }
}
