import QtQuick

Item {
    id: styledFontMetric
    visible: false

    FontMetrics {
        id: fontMetrics
        font: Qt.font({
            "family": Appearance.defaults.fontFamily,
            "pixelSize": Appearance.defaults.fontSize
        })
    }

    function widthForCharacters(count) {
        return count * fontMetrics.averageCharacterWidth;
    }
}
