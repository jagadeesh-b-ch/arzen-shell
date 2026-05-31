import QtQuick
import "./../config"
import "./../services"

Column {
    StyledText {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Time.time
        font.pointSize: Appearance.fontSize.display
    }

    StyledText {
        anchors.horizontalCenter: parent.horizontalCenter
        text: Time.fullDate
        font.pointSize: Appearance.fontSize.large
    }
}
