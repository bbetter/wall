# Changelog

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
