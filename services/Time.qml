pragma Singleton

import Quickshell
import QtQuick

Singleton {

    readonly property string dateWithTime: {
        Qt.formatDateTime(clock.date, "hh:mm:ss AP t ddd d MMM, yyyy");
    }
    readonly property string time: {
        Qt.formatDateTime(clock.date, "hh:mm");
    }
    readonly property string fullDate: {
        Qt.formatDateTime(clock.date, "ddd d MMM, yyyy");
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
