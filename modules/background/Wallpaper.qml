import "./../../services"
import QtQuick

Item {
    id: root
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#111111"
    }

    Image {
        id: bg
        anchors.fill: parent
        asynchronous: true
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        source: Wallpapers.current ? "file://" + Wallpapers.current : ""
    }
}
