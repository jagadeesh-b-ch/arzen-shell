import QtQuick
import Quickshell
import Quickshell.Services.Pam

Scope {
    id: root

    signal unlocked
    signal failed

    property string currentText: ""
    property bool unlockInProgress: false
    property bool showFailure: false
    property bool showError: false
    property string errorMessage: ""

    onCurrentTextChanged: {
        showFailure = false;
        showError = false;
    }

    Timer {
        id: safetyTimer
        interval: 15000
        onTriggered: {
            if (root.unlockInProgress) {
                root.unlockInProgress = false;
                root.showError = true;
                root.errorMessage = "Authentication timed out";
            }
        }
    }

    function tryUnlock() {
        if (currentText === "")
            return;
        unlockInProgress = true;
        showError = false;
        showFailure = false;
        safetyTimer.start();
        try {
            pam.start();
        } catch (e) {
            console.error("PAM error:", e);
            showError = true;
            errorMessage = "Authentication error";
            unlockInProgress = false;
            safetyTimer.stop();
        }
    }

    PamContext {
        id: pam
        config: "system-auth"
        onPamMessage: {
            if (responseRequired)
                respond(root.currentText);
        }
        onCompleted: result => {
            safetyTimer.stop();
            if (result == PamResult.Success)
                root.unlocked();
            else {
                root.currentText = "";
                root.showFailure = true;
            }
            root.unlockInProgress = false;
        }
    }
}
