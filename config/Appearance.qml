pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import "./../utils"

Singleton {
    id: root

    readonly property Rounding rounding: Rounding {}
    readonly property Spacing spacing: Spacing {}
    readonly property Padding padding: Padding {}
    readonly property Anim anim: Anim {}
    readonly property FontFamily fontFamily: FontFamily {}
    readonly property FontSize fontSize: FontSize {}
    readonly property Color color: Color {}
    readonly property Defaults defaults: Defaults {}

    readonly property string colorsJsonPath: `${Paths.state}/wallpaper/colors.json`.slice(7)

    function loadColors(text) {
        try {
            var data = JSON.parse(text);
            if (!data || !data.colors)
                return;
            root.defaults.color.apply(data.colors);
            updateHyprctlBorders(root.defaults.color);
        } catch (e) {
            // JSON parse failed, will retry
        }
    }

    function updateHyprctlBorders(colors) {
        var rgba = function (c, a) {
            return c ? "rgba(" + c.replace("#", "") + a + ")" : "";
        };
        var activeColor = rgba(colors.primary, "EE");
        var activeGradient = rgba(colors.primaryContainer, "99");
        var inactiveColor = rgba(colors.surface_variant, "AA");
        if (activeGradient)
            Quickshell.execDetached(["hyprctl", "eval", "hl.config({ general = { col = { active_border = { colors = { \"" + activeColor + "\", \"" + activeGradient + "\" }, angle = 45 } } } })"]);
        else if (activeColor)
            Quickshell.execDetached(["hyprctl", "eval", "hl.config({ general = { col = { active_border = \"" + activeColor + "\" } } })"]);
        if (inactiveColor)
            Quickshell.execDetached(["hyprctl", "eval", "hl.config({ general = { col = { inactive_border = \"" + inactiveColor + "\" } } })"]);
    }

    Component.onCompleted: {
        updateHyprctlBorders(root.defaults.color);
    }

    FileView {
        id: colorsFile
        path: root.colorsJsonPath
        onLoaded: {
            var t = text().trim();
            if (t)
                root.loadColors(t);
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: colorsFile.reload()
    }

    component Rounding: QtObject {
        readonly property int small: 12
        readonly property int normal: 17
        readonly property int large: 25
        readonly property int full: 1000
    }

    component Spacing: QtObject {
        readonly property int smallest: 4
        readonly property int small: 7
        readonly property int smaller: 10
        readonly property int normal: 12
        readonly property int larger: 15
        readonly property int large: 20
    }

    component Padding: QtObject {
        readonly property int smallest: 2
        readonly property int small: 4
        readonly property int smaller: 6
        readonly property int normal: 10
        readonly property int larger: 12
        readonly property int large: 15
    }

    component FontFamily: QtObject {
        readonly property string sans: "IBM Plex Sans"
        readonly property string mono: "JetBrains Mono NF"
        readonly property string material: "Material Symbols Rounded"
        readonly property string nerd: "Symbols Nerd Font Mono"
    }

    component FontSize: QtObject {
        readonly property int smallest: 8
        readonly property int small: 10
        readonly property int smaller: 12
        readonly property int normal: 13
        readonly property int larger: 15
        readonly property int large: 18
        readonly property int extraLarge: 28
        readonly property int display: 80
    }

    component AnimCurves: QtObject {
        readonly property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        readonly property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
        readonly property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
        readonly property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        readonly property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
        readonly property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
        readonly property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        readonly property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
        readonly property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
    }

    component AnimDurations: QtObject {
        readonly property int small: 200
        readonly property int normal: 400
        readonly property int large: 600
        readonly property int extraLarge: 1000
        readonly property int expressiveFastSpatial: 350
        readonly property int expressiveDefaultSpatial: 500
        readonly property int expressiveEffects: 200
    }

    component Anim: QtObject {
        readonly property AnimCurves curves: AnimCurves {}
        readonly property AnimDurations durations: AnimDurations {}
    }

    component Defaults: QtObject {
        readonly property Color color: Color {}
        readonly property int hPadding: root.padding.normal
        readonly property int vPadding: root.padding.small
        readonly property int rounding: root.rounding.normal
        readonly property int spacing: root.spacing.small
        readonly property string fontFamily: root.fontFamily.mono
        readonly property int fontSize: root.fontSize.small
        readonly property string backgroundColor: root.color.background
        readonly property string contentOnBackgroundColor: root.color.contentOnBackground
        readonly property string surfaceColor: root.color.primaryContainer
        readonly property string contentOnSurfaceColor: root.color.contentOnPrimaryContainer
        readonly property string primaryColor: root.color.primary
        readonly property string contentOnPrimaryColor: root.color.contentOnPrimary
        readonly property string outlineColor: root.color.outline
    }

    component Color: QtObject {
        property string primary: "#4CAF50"
        property string contentOnPrimary: "#FFFFFF"
        property string primaryContainer: "#C8E6C9"
        property string contentOnPrimaryContainer: "#1B5E20"
        property string primaryInverse: "#8BDB8F"
        property string secondary: "#6750A4"
        property string contentOnSecondary: "#FFFFFF"
        property string secondaryContainer: "#EADDFF"
        property string contentOnSecondaryContainer: "#21005D"
        property string tertiary: "#FF8A65"
        property string contentOnTertiary: "#FFFFFF"
        property string tertiaryContainer: "#FFDCC2"
        property string contentOnTertiaryContainer: "#3E2723"
        property string outline: "#79747E"
        property string outlineVariant: "#CAC4D0"
        property string surface: "#FFFBFE"
        property string contentOnSurface: "#1C1B1F"
        property string surfaceVariant: "#E7E0EC"
        property string contentOnSurfaceVariant: "#49454F"
        property string surfaceInverse: "#313033"
        property string contentOnSurfaceInverse: "#F4EFF4"
        property string background: "#FFFBFE"
        property string contentOnBackground: "#1C1B1F"
        property string error: "#B3261E"
        property string contentOnError: "#FFFFFF"
        property string errorContainer: "#F9DEDC"
        property string contentOnErrorContainer: "#410E0B"
        property string shadow: "#000000"

        function apply(scheme) {
            if (scheme.primary)
                primary = scheme.primary;
            if (scheme.on_primary)
                contentOnPrimary = scheme.on_primary;
            if (scheme.primary_container)
                primaryContainer = scheme.primary_container;
            if (scheme.on_primary_container)
                contentOnPrimaryContainer = scheme.on_primary_container;
            if (scheme.inverse_primary)
                primaryInverse = scheme.inverse_primary;
            if (scheme.secondary)
                secondary = scheme.secondary;
            if (scheme.on_secondary)
                contentOnSecondary = scheme.on_secondary;
            if (scheme.secondary_container)
                secondaryContainer = scheme.secondary_container;
            if (scheme.on_secondary_container)
                contentOnSecondaryContainer = scheme.on_secondary_container;
            if (scheme.tertiary)
                tertiary = scheme.tertiary;
            if (scheme.on_tertiary)
                contentOnTertiary = scheme.on_tertiary;
            if (scheme.tertiary_container)
                tertiaryContainer = scheme.tertiary_container;
            if (scheme.on_tertiary_container)
                contentOnTertiaryContainer = scheme.on_tertiary_container;
            if (scheme.outline)
                outline = scheme.outline;
            if (scheme.outline_variant)
                outlineVariant = scheme.outline_variant;
            if (scheme.surface)
                surface = scheme.surface;
            if (scheme.on_surface)
                contentOnSurface = scheme.on_surface;
            if (scheme.surface_variant)
                surfaceVariant = scheme.surface_variant;
            if (scheme.on_surface_variant)
                contentOnSurfaceVariant = scheme.on_surface_variant;
            if (scheme.inverse_surface)
                surfaceInverse = scheme.inverse_surface;
            if (scheme.inverse_on_surface)
                contentOnSurfaceInverse = scheme.inverse_on_surface;
            if (scheme.background)
                background = scheme.background;
            if (scheme.on_background)
                contentOnBackground = scheme.on_background;
            if (scheme.error)
                error = scheme.error;
            if (scheme.on_error)
                contentOnError = scheme.on_error;
            if (scheme.error_container)
                errorContainer = scheme.error_container;
            if (scheme.on_error_container)
                contentOnErrorContainer = scheme.on_error_container;
            if (scheme.shadow)
                shadow = scheme.shadow;
        }
    }
}
