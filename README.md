# wall

Simple Wallpaper Engine launcher for Linux.

> **This project is a wrapper around [linux-wallpaperengine](https://github.com/Almamu/linux-wallpaperengine) by [@Almamu](https://github.com/Almamu).**
> All actual wallpaper rendering is done by that project. `wall` adds a daemon,
> multi-monitor management, a fuzzy picker, and shell tooling on top of it.
> Please star and support the upstream project.

---

## Features

- Daemon that keeps wallpapers running across sessions
- Random, cycle, and shuffle modes with configurable intervals
- Multi-monitor support with per-monitor control
- `wall-gui` — GTK4 browser with thumbnail/video preview, search, and per-wallpaper property editing
- Works on **Hyprland**, **KDE**, and other Wayland compositors

---

## Requirements

- Arch Linux (installer uses `yay`)
- Steam with Wallpaper Engine installed
- Workshop wallpapers downloaded in Steam

> **Note:** A binary named `wall` already exists on most Linux systems (`/usr/bin/wall`).
> The installer automatically adds a shell alias to override it.

---

## Install

```bash
curl -sL https://github.com/bbetter/wall/releases/latest/download/wall-installer.sh | bash
```

Or clone and run manually:

```bash
git clone https://github.com/bbetter/wall
cd wall
bash wall-installer.sh
```

The installer:

- Installs dependencies via `yay`
- Detects your Steam library
- Downloads and installs `wall`, `wall-gui`, `wall-picker` to `~/.local/bin`
- Sets up shell config for bash, zsh, and fish
- Adds autostart (Hyprland `exec-once` or `.desktop` file for KDE/others)

---

## Commands

| Command | Description |
|---|---|
| `wall random [monitor]` | Set a random wallpaper |
| `wall next [monitor]` | Next wallpaper |
| `wall prev [monitor]` | Previous wallpaper |
| `wall cycle [seconds] [monitor]` | Auto-cycle every N seconds (default: 300) |
| `wall shuffle [seconds] [monitor]` | Shuffle mode |
| `wall <id> [monitor]` | Set wallpaper by workshop ID |
| `wall list` | List all available wallpapers |
| `wall status` | Show daemon and monitor status |
| `wall monitors` | List connected monitors |
| `wall info <id>` | Print full wallpaper metadata as JSON |
| `wall props <id>` | List customizable properties for a wallpaper |
| `wall prop set <id> <key>=<value>` | Override a wallpaper property (persisted) |
| `wall stop [monitor]` | Stop wallpaper(s) and daemon |
| `wall set <fps\|scaling> <value>` | Update a config setting and restart daemon |
| `wall log` | Tail the daemon log (useful for debugging) |
| `wall cache [clear\|rebuild]` | Manage the wallpaper metadata cache |
| `wall update` | Update all wall scripts to latest version |
| `wall version` | Print current version |
| `wall-gui` | GTK4 GUI: browse, preview, edit properties, apply |
| `wall-picker` | Alias for `wall-gui` (backwards compat) |

---

## Multi-monitor

All commands accept an optional monitor name:

```bash
wall random DP-1
wall cycle 60 HDMI-A-1
wall-gui           # prompts for monitor selection when multiple connected
```

Run `wall monitors` to list connected monitor names.

---

## Autostart

**Hyprland** — the installer appends to `~/.config/hypr/hyprland.conf`:

```
exec-once = wall random
```

**KDE / other** — the installer creates `~/.config/autostart/wall.desktop`.

---

## Configuration

Use `wall set` to change settings without editing files manually:

```bash
wall set fps 30
wall set scaling fit
```

Changes take effect after the daemon restarts. `wall set` handles that automatically if the daemon is running.

| Setting | Values | Default | Description |
|---|---|---|---|
| `fps` | any integer | `60` | Wallpaper frame rate |
| `scaling` | `fill` `fit` `stretch` `default` | `fill` | How the wallpaper fills the screen |
| `audio` | `0` `1` | `0` | Audio output (`0` = silent, `1` = enabled) |

Config file location: `~/.config/wall/config`

---

## Wallpaper Properties

Some wallpapers expose customizable properties (colors, sliders, toggles, dropdowns) defined by their author.

**In wall-gui:** select any wallpaper to see its Properties panel. Changes are staged and written when you click Apply.

**From the CLI:**

```bash
# list all properties for a wallpaper
wall props 2370927443

# override a property (persisted to ~/.config/wall/props/<id>)
wall prop set 2370927443 bloom=true
wall prop set 2370927443 speed=0.75
```

Property overrides are saved per-wallpaper and automatically applied every time that wallpaper is launched.

---

## Releases

`wall update` checks the latest [GitHub release](https://github.com/bbetter/wall/releases) and updates only if a newer version is available. The installer also always installs from the latest release tag rather than `main`.

To publish a new release:

```bash
# bump VERSION in bin/wall, then:
git tag v0.2.0
git push origin v0.2.0
```

Then create a release on GitHub from that tag. Users will get it on next `wall update`.

---

## Dependencies

Installed automatically:

| Package | Purpose |
|---|---|
| `linux-wallpaperengine` | Renders Wallpaper Engine scenes |
| `jq` | Parses workshop metadata |
| `python-gobject` + `gtk4` | GTK4 GUI (`wall-gui`) |
| `ffmpeg` | Video metadata (`ffprobe`) for resolution in `wall info` |
| `mpv` | Video preview in `wall-picker` (via GStreamer/GTK4) |
