pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

Item {
    id: root

    required property Item source
    property color tintColor: "#EADDFF"
    property real tintAmount: 0.2
    property real blurAmount: 24
    property real frostOpacity: 0.1
    property int radius: 17

    clip: true

    ShaderEffectSource {
        id: feed
        sourceItem: root.source
        live: true
        sourceRect: Qt.rect(root.mapToItem(root.source, 0, 0).x, root.mapToItem(root.source, 0, 0).y, root.width, root.height)
    }

    layer.enabled: true
    layer.effect: MultiEffect {
        blurEnabled: true
        blurMax: Math.max(root.blurAmount, 32)
        blurAmount: root.blurAmount
        colorizationEnabled: true
        colorizationColor: root.tintColor
        colorizationAmount: root.tintAmount
    }

    Rectangle {
        anchors.fill: parent
        color: "white"
        opacity: root.frostOpacity
        radius: root.radius
        border.color: Qt.rgba(1, 1, 1, 0.06)
        border.width: 1
    }
}
