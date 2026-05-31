import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import "./../../config"

ColumnLayout {
    id: root
    spacing: Appearance.spacing.normal

    required property QtObject context
    property alias passwordField: passwordField

    RowLayout {
        spacing: Appearance.spacing.normal
        Layout.topMargin: Appearance.spacing.large

        TextField {
            id: passwordField
            implicitWidth: 320
            padding: Appearance.padding.large
            focus: true
            enabled: !root.context.unlockInProgress
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            placeholderText: "Password"
            color: Appearance.defaults.color.contentOnSurfaceInverse
            placeholderTextColor: Appearance.defaults.color.placeholderOnInverse

            background: Rectangle {
                color: Appearance.defaults.color.surfaceInverseOverlay
                radius: Appearance.defaults.rounding
                border.color: Appearance.defaults.color.surfaceInverseBorder
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

        Button {
            text: "Unlock"
            padding: Appearance.padding.large
            focusPolicy: Qt.NoFocus
            enabled: !root.context.unlockInProgress && root.context.currentText !== ""

            background: Rectangle {
                color: parent.enabled ? Appearance.defaults.color.primary : Appearance.defaults.color.outline
                radius: Appearance.defaults.rounding
            }
            contentItem: Text {
                text: parent.text
                color: Appearance.defaults.color.contentOnPrimary
                font.pointSize: Appearance.fontSize.normal
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onClicked: root.context.tryUnlock()
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
