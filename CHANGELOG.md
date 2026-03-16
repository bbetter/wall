# Changelog

## v1.0.3
- Fix: wall-gui startup blocked the UI while loading wallpapers, monitors, and favorites; data is now fetched in a background thread with a spinner shown until ready
- Fix: get_wall_bin() now prefers ~/.local/bin/wall explicitly to avoid picking up the system wall utility (util-linux) when launched from Hyprland's exec environment

## v1.0.2
- Fix: wall-gui failed to start due to D-Bus registration timeout; removed application_id from Gtk.Application to bypass D-Bus registration

## v1.0.1
- Fix: clamp setting and per-wallpaper flags (disable-particles, disable-parallax, disable-mouse) were dropped by the v1.0.0 refactor; restored in both CLI and GUI

## v1.0.0
- Stable release with fully documented codebase
- Comprehensive doc comments on every function in `bin/wall` (bash) and every method in `bin/wall-gui` (Python)
- File headers describing architecture, key concepts, data flows, and dependencies
- Section dividers grouping related code in both files
- Inline comments on non-obvious logic (shuffle index math, tick scheduling, playlist mode detection, config loading order)
- No behaviour changes from v0.9.5

## v0.9.5
- Fix: global settings (FPS, scaling, audio, volume, fullscreen pause) were never actually applied — config was sourced before defaults were set, so defaults always won; fixed load order
- This means all `wall set` changes now take effect properly for the first time

## v0.9.4
- Fix: settings apply now restores wallpapers (daemon restore logic on startup)
- Fix: wallpapers on idle monitors no longer pause when a fullscreen app opens on another monitor
- Add `wall reload` command — restarts daemon and restores all active wallpapers
- Settings: single restart on apply instead of one per setting
- Settings: "Pause on fullscreen" toggle (off by default)

## v0.9.3
- Favorites playlist: protected built-in playlist, ★/☆ toggle in detail panel, ★ badge in list
- Drag-and-drop reordering of entries in any playlist (⠿ handle)
- `wall version` now fetches and prints current version's release notes
- `wall version --all` prints the full changelog
- `wall update` prints what's new after a successful update
- `wall update --whatsnew` shows next version's notes without updating

## v0.9.2
- Silent toggle and volume slider in global settings
- Volume passed as `--volume` flag to linux-wallpaperengine when audio is enabled

## v0.9.1
- Web and application wallpaper types now appear in the list with ⛔ unsupported banners
- Scene wallpapers show a ⚠ warning about potential feature gaps
- Type filter chips: All / Video / Scene / Web / Application

## v0.9.0
- Type filter chips below search bar
- Exclude checkbox removed from GUI (use playlists to curate instead)
- Comprehensive UI/UX overhaul: async info loading, spinner, overflow ⋮ menu,
  status strip, keyboard shortcuts (/ to focus search, Esc to clear),
  ↻ refresh button, Show more/less for long descriptions

## v0.8.0
- Named, ordered wallpaper playlists (`wall playlist create/add/remove/delete/list/show/play/shuffle`)
- Playlist modes: `playlist` (ordered) and `playlist_shuffle`
- Playlist window in GUI: two-pane layout, New/Delete, Play/Shuffle with monitor and interval controls
- "Add to Playlist" in wallpaper detail panel overflow menu

## v0.7.0
- Settings screen in GUI (FPS, scaling, audio)
- `--silent` flag support for muting wallpaper audio
- HTML tags stripped from wallpaper property labels

## v0.6.0
- BBCode rendered in wallpaper descriptions (bold, italic, lists, links)
- Fix: GUI stays open after applying a wallpaper
- Fix: Gtk.Switch no longer stretches in properties grid

## v0.5.1
- Scene wallpapers with unsupported features excluded from random/cycle/shuffle
- Warning shown in GUI for scene wallpapers with missing display features

## v0.5.0
- Full GTK4 GUI (`wall-gui`) with wallpaper properties support
- Per-wallpaper property overrides saved and restored

## v0.4.1
- Fix: self-update no longer corrupts the script on overwrite

## v0.4.0
- `wall info` shows video metadata (resolution, FPS, duration, codec) via ffprobe
- GTK4 picker polish and seven UX improvements
- Cache progress indicator, empty state, log clear command

## v0.3.0
- GTK4 picker (`wall-picker`) with inline media preview
- `wall info` command with expanded cache (type field)
- Open in Steam and share Steam URL from picker

## v0.2.2
- Minor stability fixes

## v0.2.1
- Fix: status crash when called outside a function context

## v0.2.0
- Initial public release with cycle, shuffle, multi-monitor support
