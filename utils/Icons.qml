pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property var osIcons: ({
            almalinux: "",
            alpine: "",
            arch: "",
            archcraft: "",
            arcolinux: "",
            artix: "",
            centos: "",
            debian: "",
            devuan: "",
            elementary: "",
            endeavouros: "",
            fedora: "",
            freebsd: "",
            garuda: "",
            gentoo: "",
            hyperbola: "",
            kali: "",
            linuxmint: "󰣭",
            mageia: "",
            openmandriva: "",
            manjaro: "",
            neon: "",
            nixos: "",
            opensuse: "",
            suse: "",
            sles: "",
            sles_sap: "",
            "opensuse-tumbleweed": "",
            parrot: "",
            pop: "",
            raspbian: "",
            rhel: "",
            rocky: "",
            slackware: "",
            solus: "",
            steamos: "",
            tails: "",
            trisquel: "",
            ubuntu: "",
            vanilla: "",
            void: "",
            zorin: ""
        })

    readonly property var weatherIcons: ({
            "113": "clear_day",
            "116": "partly_cloudy_day",
            "119": "cloud",
            "122": "cloud",
            "143": "foggy",
            "176": "rainy",
            "179": "rainy",
            "182": "rainy",
            "185": "rainy",
            "200": "thunderstorm",
            "227": "cloudy_snowing",
            "230": "snowing_heavy",
            "248": "foggy",
            "260": "foggy",
            "263": "rainy",
            "266": "rainy",
            "281": "rainy",
            "284": "rainy",
            "293": "rainy",
            "296": "rainy",
            "299": "rainy",
            "302": "weather_hail",
            "305": "rainy",
            "308": "weather_hail",
            "311": "rainy",
            "314": "rainy",
            "317": "rainy",
            "320": "cloudy_snowing",
            "323": "cloudy_snowing",
            "326": "cloudy_snowing",
            "329": "snowing_heavy",
            "332": "snowing_heavy",
            "335": "snowing",
            "338": "snowing_heavy",
            "350": "rainy",
            "353": "rainy",
            "356": "rainy",
            "359": "weather_hail",
            "362": "rainy",
            "365": "rainy",
            "368": "cloudy_snowing",
            "371": "snowing",
            "374": "rainy",
            "377": "rainy",
            "386": "thunderstorm",
            "389": "thunderstorm",
            "392": "thunderstorm",
            "395": "snowing"
        })

    readonly property var desktopEntrySubs: ({})

    readonly property var categoryIcons: ({
            WebBrowser: "web",
            Printing: "print",
            Security: "security",
            Network: "chat",
            Archiving: "archive",
            Compression: "archive",
            Development: "code",
            IDE: "code",
            TextEditor: "edit_note",
            Audio: "music_note",
            Music: "music_note",
            Player: "music_note",
            Recorder: "mic",
            Game: "sports_esports",
            FileTools: "files",
            FileManager: "files",
            Filesystem: "files",
            FileTransfer: "files",
            Settings: "settings",
            DesktopSettings: "settings",
            HardwareSettings: "settings",
            TerminalEmulator: "terminal",
            ConsoleOnly: "terminal",
            Utility: "build",
            Monitor: "monitor_heart",
            Midi: "graphic_eq",
            Mixer: "graphic_eq",
            AudioVideoEditing: "video_settings",
            AudioVideo: "music_video",
            Video: "videocam",
            Building: "construction",
            Graphics: "photo_library",
            "2DGraphics": "photo_library",
            RasterGraphics: "photo_library",
            TV: "tv",
            System: "host",
            Office: "content_paste"
        })

    property string osIcon: ""
    property string osName

    function getDesktopEntry(name: string): DesktopEntry {
        name = name.toLowerCase().replace(/ /g, "-");

        if (desktopEntrySubs.hasOwnProperty(name))
            name = desktopEntrySubs[name];

        return DesktopEntries.applications.values.find(a => a.id.toLowerCase() === name) ?? null;
    }

    function getAppIcon(name: string, fallback: string): string {
        return Quickshell.iconPath(getDesktopEntry(name)?.icon, fallback);
    }

    function getAppCategoryIcon(name: string, fallback: string): string {
        const categories = getDesktopEntry(name)?.categories;

        if (categories)
            for (const [key, value] of Object.entries(categoryIcons))
                if (categories.includes(key))
                    return value;
        return fallback;
    }

    function getNetworkIcon(strength: int): string {
        if (strength >= 80)
            return "signal_wifi_4_bar";
        if (strength >= 60)
            return "network_wifi_3_bar";
        if (strength >= 40)
            return "network_wifi_2_bar";
        if (strength >= 20)
            return "network_wifi_1_bar";
        return "signal_wifi_0_bar";
    }

    function getBluetoothIcon(icon: string): string {
        if (icon.includes("headset") || icon.includes("headphones"))
            return "headphones";
        if (icon.includes("audio"))
            return "speaker";
        if (icon.includes("phone"))
            return "smartphone";
        return "bluetooth";
    }

    function getPowerProfileIcon(powerProfile: int): string {
        if (powerProfile === PowerProfile.Performance) {
            return "\uEB9B"
        }
        if (powerProfile === PowerProfile.Balanced) {
            return "\uEAF6"
        }
        if (powerProfile === PowerProfile.PowerSaver) {
            return "\uF15F"
        }
        return "\uEB8B"
    }

    function getBatteryIcon(percentage: int, isCharging: bool): string {
        if (percentage >= 95) {
            return "battery_full"
        }
        if (percentage >= 80) {
            if (isCharging) {
                return "battery_charging_90"
            } else {
                return "battery_6_bar"
            }
        }
        if (percentage >= 65) {
            if (isCharging) {
                return "battery_charging_80"
            } else {
                return "battery_5_bar"
            }
        }
        if (percentage >= 50) {
            if (isCharging) {
                return "battery_charging_60"
            } else {
                return "battery_4_bar"
            }
        }
        if (percentage >= 35) {
            if (isCharging) {
                return "battery_charging_50"
            } else {
                return "battery_3_bar"
            }
        }
        if (percentage >= 20) {
            if (isCharging) {
                return "battery_charging_30"
            } else {
                return "battery_2_bar"
            }
        }
        if (percentage >= 5) {
            if (isCharging) {
                return "battery_charging_20"
            } else {
                return "battery_1_bar"
            }
        }
        if (percentage >= 0) {
            if (isCharging) {
                return "battery_charging_full"
            } else {
                return "battery_0_bar"
            }
        }
    }

    function getVolumeIcon(percentage: int, muted: bool): string {
        if (muted) {
            return "volume_off"
        }
        if (percentage >= 75) {
            return "volume_up"
        }
        if (percentage >= 25) {
            return "volume_down"
        }
        if (percentage > 0) {
            return "volume_mute"
        }
        return "volume_off"
    }

    function getBrightnessIcon(percentage: int): string {
        if (percentage >= 75) {
            return "brightness_7"
        }
        if (percentage >= 25) {
            return "brightness_6"
        }
        return "brightness_5"
    }

    function getWeatherIcon(code: string): string {
        if (weatherIcons.hasOwnProperty(code))
            return weatherIcons[code];
        return "air";
    }

    FileView {
        path: "/etc/os-release"
        onLoaded: {
            const lines = text().split("\n");
            let osId = lines.find(l => l.startsWith("ID="))?.split("=")[1];
            if (root.osIcons.hasOwnProperty(osId))
                root.osIcon = root.osIcons[osId];
            else {
                const osIdLike = lines.find(l => l.startsWith("ID_LIKE="))?.split("=")[1];
                if (osIdLike)
                    for (const id of osIdLike.split(" "))
                        if (root.osIcons.hasOwnProperty(id))
                            return root.osIcon = root.osIcons[id];
            }

            let nameLine = lines.find(l => l.startsWith("PRETTY_NAME="));
            if (!nameLine)
                nameLine = lines.find(l => l.startsWith("NAME="));
            root.osName = nameLine.split("=")[1].slice(1, -1);
        }
    }
}
