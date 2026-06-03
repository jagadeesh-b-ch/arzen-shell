pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: appsService

    property var historyData: ({})
    property bool appsReady: false

    Timer {
        id: retryTimer
        interval: 200
        repeat: true
        running: true
        onTriggered: {
            if (DesktopEntries.applications.values.length > 0) {
                appsService.appsReady = true;
                retryTimer.stop();
            }
        }
    }

    function filterApps(query) {
        var q = query.trim().toLowerCase();
        var apps = DesktopEntries.applications.values;
        if (!apps || apps.length === 0)
            return [];

        var filtered = [];
        for (var i = 0; i < apps.length; i++) {
            var app = apps[i];
            if (app.noDisplay)
                continue;
            if (q === "" || app.name.toLowerCase().includes(q) || (app.genericName && app.genericName.toLowerCase().includes(q))) {
                filtered.push(app);
            }
        }

        filtered.sort(function (a, b) {
            var ha = historyData[a.name];
            var hb = historyData[b.name];
            var sa = ha ? 1 : 0;
            var sb = hb ? 1 : 0;
            if (sa !== sb)
                return sb - sa;
            if (sa && sb) {
                if (ha.count !== hb.count)
                    return hb.count - ha.count;
                if (ha.lastUsed !== hb.lastUsed)
                    return hb.lastUsed - ha.lastUsed;
            }
            return a.name.localeCompare(b.name);
        });

        return filtered;
    }

    function recordUsage(appName) {
        var now = Math.floor(Date.now() / 1000);
        var entry = historyData[appName];
        if (entry) {
            entry.count++;
            entry.lastUsed = now;
        } else {
            historyData[appName] = {
                count: 1,
                lastUsed: now
            };
        }
    }

    function launch(entry) {
        recordUsage(entry.name);
        var command = entry.exec;
        if (Hyprland.activeWsId > 0) {
            Hyprland.dispatch("exec workspace " + Hyprland.activeWsId + " " + command);
        } else {
            entry.execute();
        }
    }
}
