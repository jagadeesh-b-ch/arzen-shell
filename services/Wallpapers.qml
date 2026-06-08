pragma Singleton

import "./../utils"
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string currentNamePath: `${Paths.state}/wallpaper/path.txt`.slice(7)
    readonly property string path: `${Paths.pictures}/Wallpapers`.slice(7)
    readonly property list<string> extensions: ["jpg", "jpeg", "png", "webp", "tif", "tiff"]

    readonly property list<Wallpaper> list: wallpapers.instances
    property bool showPreview: false
    readonly property string current: showPreview ? previewPath : actualCurrent
    property string previewPath
    property string actualCurrent
    property bool bothReady: false

    function fuzzyQuery(search: string): var {
        if (!search)
            return list;
        var lower = search.toLowerCase();
        return list.filter(w => w.name.toLowerCase().includes(lower) || w.path.toLowerCase().includes(lower));
    }

    function setWallpaper(path: string): void {
        actualCurrent = path;
        Quickshell.execDetached(["mkdir", "-p", `${Paths.state}/wallpaper`.slice(7)]);
        Quickshell.execDetached(["sh", "-c", `printf '%s' '${path}' > ${currentNamePath}`]);
        Quickshell.execDetached(["matugen", "image", path, "--source-color-index", "0"]);
    }

    function preview(path: string): void {
        previewPath = path;
        showPreview = true;
    }

    function stopPreview(): void {
        showPreview = false;
    }

    IpcHandler {
        target: "wallpaper"

        function get(): string {
            return root.actualCurrent;
        }

        function set(path: string): void {
            root.setWallpaper(path);
        }

        function list(): string {
            return root.list.map(w => w.path).join("\n");
        }
    }

    function _checkBothReady() {
        if (!root.bothReady && root.fileViewReady && root.processDone) {
            root.bothReady = true;
            if (!root.actualCurrent && wallpapers.instances.length > 0)
                root.setWallpaper(wallpapers.instances[0].path);
        }
    }

    property bool fileViewReady: false
    property bool processDone: false

    FileView {
        path: root.currentNamePath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            root.fileViewReady = true;
            var saved = text().trim();
            if (saved) {
                root.actualCurrent = saved;
            }
            root._checkBothReady();
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            findProcess.running = false;
            refreshTimer.start();
        }
    }

    Timer {
        id: refreshTimer
        interval: 500
        onTriggered: {
            findProcess.running = true;
        }
    }

    Process {
        id: findProcess
        running: true
        command: ["find", root.path, "-type", "d", "-path", '*/.*', "-prune", "-o", "-not", "-name", '.*', "-type", "f", "-print"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.processDone = true;
                var sorted = text.trim().split("\n").filter(w => root.extensions.includes(w.slice(w.lastIndexOf(".") + 1))).sort();
                wallpapers.model = sorted;
                root._checkBothReady();
            }
        }
    }

    Variants {
        id: wallpapers

        Wallpaper {}
    }

    component Wallpaper: QtObject {
        required property string modelData
        readonly property string path: modelData
        readonly property string name: path.slice(path.lastIndexOf("/") + 1, path.lastIndexOf("."))
    }
}
