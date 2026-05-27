pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property string shell: "bash"
    readonly property string terminal: "ghostty"
    readonly property string audio: "pavucontrol"
    readonly property string bluetooth: "bluetui"
    readonly property string network: "nmtui"
    readonly property string resourceMonitor: "btop"
}
