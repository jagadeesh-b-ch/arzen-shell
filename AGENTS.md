# Quickshell Config — Hyprland Top Bar

Part of `~/.config` dotfiles repo (see `../AGENTS.md` for broader context).

## Entry point
- `shell.qml` — root `Scope` → `TopBar`
- Quickshell auto-loads from `~/.config/quickshell/`
- Run shell: `quickshell`
- Run locker: `quickshell -p ~/Projects/arzen-shell/lock.qml`
- No build/lint/test — QML interpreted

## Verifying changes
After modifying any UI file (modules, widgets, services, config), run the relevant command to check for QML errors:
- Shell changes: `quickshell` (kill existing instance first)
- Locker changes: `quickshell -p ~/Projects/arzen-shell/lock.qml` (use `nohup ... & disown` — do NOT kill the locker process, as Hyprland treats that as a crash and locks the user out; the user will unlock it manually)
Fix any errors reported before considering the change complete.

## Import conventions
- Relative imports only: `import "./../services"`, `import "./../../services"`, `import "./../config"`, `import "./../widgets"`
- Services, config, and utils each declare a `qmldir` as a proper QML module
- `modules/` has no `qmldir` but is importable as `import "./modules"` (exposes direct-child `.qml` files as types)
- All services use `pragma Singleton` and are declared in `services/qmldir`

## Directory layout
| Path | Purpose |
|---|---|
| `shell.qml` | Entry point |
| `modules/TopBar.qml` | Per-screen `StyledWindow` via `Variants` + `Scope` |
| `modules/LeftModules.qml` | Row: AppLauncher, WorkspaceWidget, ClockWidget |
| `modules/RightModules.qml` | Row: ResourcesWidget, ConnectivityWidget, OutputWidget, PowerWidget |
| `modules/background/` | Wallpaper display layer (separate `StyledWindow` per screen, not auto-loaded from shell.qml) |
| `modules/*/*.qml` | Sub-modules (launcher, workspaces, time, resources, connectivity, output, power) |
| `widgets/` | Reusable components (`InteractiveView`, `StyledText`, `StyledWindow`, `MaterialIcon`, `PopOutWindow`, `CachingImage`, `HorizontalSlider`) |
| `services/` | `pragma Singleton` singletons: Audio (Pipewire), Bluetooth, Brightness, Hyprland, Network (nmcli), PopOutManager, Resources, Time, Wallpapers |
| `config/` | `Appearance.qml` (theme singleton), `DefaultApps.qml` (app launcher commands), `StyledFontMetric.qml` |
| `utils/` | `Paths.qml` (state/pictures dirs), `Icons.qml` (icon name map), `scripts/` (find-cpu-temp.sh, fuzzysort.js) |

## Key conventions
- **`InteractiveView`** — clickable card wrapper. Children go into its `content` property (default property alias). Signals: `clicked`, `hover(bool)`.
- **`StyledWindow`** — extends Quickshell `PanelWindow` with WlrLayershell. Requires `name` property. Namespace is `archie-${name}`.
- **`PopOutWindow`** — `PopupWindow` subclass with 3-second auto-hide timer. Uses `PopOutManager` (singleton) for mutual exclusion. Methods: `show()`, `forceHide()`.
- **`MaterialIcon`** — `StyledText` with `font.family: Appearance.fontFamily.material` ("Material Symbols Rounded"). Icon name = `text` property.
- **`Appearance`** (pragma Singleton) — provides `rounding`, `spacing`, `padding`, `fontFamily`, `fontSize`, animation curves/durations, defaults. Import via `config/Appearance.qml` or `import "./../config"`.
- **`DefaultApps`** (pragma Singleton) — maps app roles to commands: `shell` (bash), `terminal` (ghostty), `audio` (pavucontrol), `bluetooth` (bluetui), `network` (nmtui), `resourceMonitor` (btop).
- **`Variants`** + `Scope` — Quickshell pattern for multi-screen support (`model: Quickshell.screens`).
- **`Icons.qml`** (pragma Singleton, utils/) — central icon name map, used throughout modules.

## Gotchas
- **`StyledFontMetric` is NOT a `pragma Singleton`** — cannot call `widthForCharacters()` statically. Use `Row` layout instead of fixed-width calculations for text+icon pairs.
- **`Paths.qml` paths use `.slice(7)`** — strips leading `/run/...` mount prefix for `Paths.state` and `Paths.pictures`.
- **CPU temp** — `services/Resources.qml` delegates to `utils/scripts/find-cpu-temp.sh` (5-level fallback: thermal_zone type match → any thermal_zone → hwmon label match → any hwmon → `sensors -j` from lm-sensors). Output in millidegrees.

## External dependencies
- **Hyprland** — required for `Hyprland.dispatch()`, workspaces, clients
- **Pipewire** — audio via `Quickshell.Services.Pipewire`
- **nmcli** — network scanning (networkmanager package)
- **archie** — wallpaper set/preview commands
- **btop** — launched on resource widget click
