import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Fusion
import "./../config"

TextField {
    id: root

    property int pointSize: Appearance.defaults.fontSize
    property int displayLength: 32
    property real letterSpacing: 0
    property string surfaceBackground: Appearance.defaults.surfaceColor
    property string outlineBackground: Appearance.defaults.outlineColor
    property string focusOutlineBackground: Appearance.defaults.primaryColor

    font.family: Appearance.defaults.fontFamily
    font.pointSize: pointSize
    font.letterSpacing: letterSpacing

    maximumLength: displayLength

    padding: Appearance.padding.large
    implicitWidth: {
        var txt = "";
        for (var i = 0; i < displayLength; i++)
            txt += "W";
        return fontMetrics.advanceWidth(txt) + padding * 2;
    }
    implicitHeight: fontMetrics.height + padding * 2

    color: Appearance.defaults.contentOnSurfaceColor
    placeholderTextColor: Appearance.defaults.outlineColor

    background: Rectangle {
        color: root.surfaceBackground
        radius: Appearance.defaults.rounding
        border.color: root.activeFocus ? root.focusOutlineBackground : root.outlineBackground
        border.width: 1
    }

    FontMetrics {
        id: fontMetrics
        font: root.font
    }
}
