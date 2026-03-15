# wall

Simple Wallpaper Engine launcher for Linux.

Run your **Steam Wallpaper Engine** workshop wallpapers on Linux via [`linux-wallpaperengine`](https://github.com/Almamu/linux-wallpaperengine).

---

## Features

- Daemon that keeps wallpapers running across sessions
- Random, cycle, and shuffle modes with configurable intervals
- Multi-monitor support with per-monitor control
- `wall-picker` — fuzzy browse and search by title or tags
- `wall-preview` — thumbnail preview before applying
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
bash <(curl -s https://raw.githubusercontent.com/bbetter/wall/main/wall-installer.sh)
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
- Downloads and installs `wall`, `wall-picker`, `wall-preview` to `~/.local/bin`
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
| `wall stop [monitor]` | Stop wallpaper(s) and daemon |
| `wall log` | Tail the daemon log (useful for debugging) |
| `wall cache [clear\|rebuild]` | Manage the wallpaper metadata cache |
| `wall update` | Update all wall scripts to latest version |
| `wall version` | Print current version |
| `wall-picker` | Interactive fuzzy picker |

---

## Multi-monitor

All commands accept an optional monitor name:

```bash
wall random DP-1
wall cycle 60 HDMI-A-1
wall-picker        # prompts for monitor selection when multiple connected
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

Config file: `~/.config/wall/config` (written by installer)

```bash
STEAM_LIB=/path/to/SteamLibrary/steamapps

# Optional overrides:
FPS=60          # wallpaper frame rate
SCALING=fill    # fill | fit | stretch | default
```

---

## Dependencies

Installed automatically:

| Package | Purpose |
|---|---|
| `linux-wallpaperengine` | Renders Wallpaper Engine scenes |
| `jq` | Parses workshop metadata |
| `fuzzel` | Fuzzy picker UI (`wall-picker`) |
| `mpv` | Thumbnail preview (`wall-preview`) |
