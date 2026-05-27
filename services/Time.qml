pragma Singleton

import Quickshell
import QtQuick

Singleton {

  readonly property string time: {
    Qt.formatDateTime(clock.date, "hh:mm:ss AP t ddd d MMM, yyyy")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}

