import QtQuick
import QtQuick.Layouts
import "./../../config"
import "./../../widgets"

ColumnLayout {
    id: root
    spacing: Appearance.spacing.normal

    required property QtObject context
    property alias passwordField: passwordField

    StyledTextField {
        id: passwordField
        Layout.topMargin: Appearance.spacing.large
        Layout.alignment: Qt.AlignHCenter
        focus: true
        enabled: !root.context.unlockInProgress
        echoMode: TextInput.Password
        inputMethodHints: Qt.ImhSensitiveData
        placeholderText: "Password"
        letterSpacing: 4

        onTextChanged: root.context.currentText = text
        onAccepted: root.context.tryUnlock()
        Connections {
            target: root.context
            function onCurrentTextChanged() {
                if (passwordField.text !== root.context.currentText)
                    passwordField.text = root.context.currentText;
            }
        }
    }

    StyledText {
        Layout.alignment: Qt.AlignHCenter
        Layout.minimumHeight: infoMetrics.height
        color: Appearance.defaults.color.primary
        opacity: root.context.unlockInProgress ? 1 : 0
        text: "Verifying"
        NumberAnimation on opacity {
            from: 1; to: 0.3; duration: 600; loops: Animation.Infinite
            running: root.context.unlockInProgress
            easing.type: Easing.InOutSine
        }
    }

    StyledText {
        Layout.alignment: Qt.AlignHCenter
        Layout.minimumHeight: infoMetrics.height
        color: Appearance.defaults.color.error
        text: root.context.showFailure || root.context.showError ? (root.context.showError ? root.context.errorMessage : "Incorrect password") : ""
    }

    FontMetrics {
        id: infoMetrics
        font.family: Appearance.defaults.fontFamily
        font.pointSize: Appearance.defaults.fontSize
    }
}
