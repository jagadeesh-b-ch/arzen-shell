import QtQuick
import QtQuick.Controls
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
        color: Appearance.defaults.color.contentOnSurfaceInverse
        placeholderTextColor: Appearance.defaults.color.outlineVariant

        background: Rectangle {
            color: Appearance.defaults.color.surfaceInverse
            radius: Appearance.defaults.rounding
            border.color: parent.activeFocus ? Appearance.defaults.color.primary : Appearance.defaults.color.outline
            border.width: 1
        }

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

    Label {
        visible: root.context.showFailure
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: false
        text: "Incorrect password"
        color: Appearance.defaults.color.error
        font.pointSize: Appearance.fontSize.normal
    }

    Label {
        visible: root.context.showError
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: false
        text: root.context.errorMessage
        color: Appearance.defaults.color.error
        font.pointSize: Appearance.fontSize.normal
    }
}
