# User Report Fix Flow

Reusable playbook for every fix cycle: triage reports → reproduce → fix in `wall` and/or `linux-wallpaperengine` → release both.

---

## Repos

| Repo | Path |
|------|------|
| `wall` | `/home/andrii/MyScripts/wall` |
| `linux-wallpaperengine` | `/home/andrii/MyAIProjects/linux-wallpaperengine` |

---

## Step 1 — Collect and triage reports

Reports are saved by users via `wall report` or the GUI "Report Issue…" dialog.  
They land in `~/.config/wall/reports/` as Markdown files.

```bash
wall report list
```

Each report contains:
- Category, wallpaper ID, Steam Workshop URL
- System info (OS, kernel, session type, engine path, wall version, config)
- Engine log — the most diagnostic section; focus on `[ENGINE] stderr:` lines

**Triage by error pattern:**

| Stderr pattern | Likely cause | Fix target |
|---|---|---|
| `Failed to initialize GLEW: No GLX display` | Non-fatal EGL/Wayland message printed as error | engine |
| `filesystem error: ... Success [path]` | `std::error_code()` default gives misleading "Success" | engine |
| `Unknown object type found: {...}` | Group container object not recognized | engine |
| `ScriptEngine [evaluate]: TypeError` | Script accesses undefined property | engine |
| `pure virtual method called` / `terminate called` | C++ crash in engine | engine |
| `Shader has a require block #require X` | Unimplemented shader feature | engine |
| `Text objects are not supported` | Text layer not rendered | engine |
| Report log full of unrelated `wall info` lines | Log extraction is too broad | wall |
| `Monitor | —` in report | Monitor not resolved when `--id` passed | wall |
| Wrong category for clear issue type | GUI dialog defaults to first category | wall |

---

## Step 2 — Reproduce

For each bug, establish: what input reliably triggers it, and what the wrong vs. correct output looks like.

**`wall` bugs:** reproducible locally with a running wallpaper and CLI/GUI.
**Engine bugs:** require the specific wallpaper ID from the report. Run the engine and check stderr.

Reproduction template:
```
Trigger:  <exact command or action>
Before:   <wrong output / symptom>
After:    <correct output / behavior>
```

---

## Step 3 — Fix in `wall`

**Repo:** `/home/andrii/MyScripts/wall`  
**Main files:** `bin/wall` (bash), `bin/wall-gui` (Python/GTK4)

Work in the repo directly on `main`. Each fix is a separate commit.

After implementing and manually verifying:

```bash
git add bin/wall bin/wall-gui   # only files you touched
git commit -m "fix: <short description>"
```

---

## Step 4 — Fix in `linux-wallpaperengine`

**Repo:** `/home/andrii/MyAIProjects/linux-wallpaperengine`  
**Main source dirs:** `src/WallpaperEngine/`

After making changes, verify the build compiles cleanly before releasing:

```bash
cd /home/andrii/MyAIProjects/linux-wallpaperengine
cmake --build build --parallel
```

Commit each fix:
```bash
git add <files>
git commit -m "fix: <short description>"
```

---

## Step 5 — Update wallpaper compatibility notes

For every wallpaper where tinkering occurred (partial fix, known workaround, skipped rendering, open investigation), add or update an entry in `_WALLPAPER_NOTES` inside `bin/wall`:

```bash
# bin/wall — find the _WALLPAPER_NOTES variable near the top
_WALLPAPER_NOTES='{
  "<workshop_id>": [
    "Short description of what was found or changed, referencing engine version if relevant"
  ],
  ...
}'
```

**Rules:**
- One entry per wallpaper ID, even if multiple issues were found
- Be honest: if something is skipped/missing, say so — don't imply it's fully fixed
- Reference engine version when a fix landed (e.g. `fixed in engine v0.0.19`)
- Mark open investigations explicitly: `under investigation`
- These notes are shown to users on the wallpaper detail page in the GUI

This step is part of every release that touched a specific wallpaper, not just when a full fix landed.

---

## Step 6 — Release `wall`

1. Bump the version in `bin/wall`:
   ```bash
   # Edit bin/wall line: VERSION="x.y.z"
   ```

2. Commit with `[RELEASE]` in the message — this is what triggers the GitHub Actions workflow:
   ```bash
   git add bin/wall
   git commit -m "[RELEASE] vX.Y.Z: <summary of what changed>"
   git push
   ```

3. GitHub Actions (`.github/workflows/release.yml`) automatically:
   - Reads `VERSION` from `bin/wall`
   - Creates git tag `vX.Y.Z`
   - Publishes `wall-installer.sh` as a release asset
   - Generates release notes from commits

No manual step needed after the push.

---

## Step 6 — Release `linux-wallpaperengine`

1. Ensure the build is up to date:
   ```bash
   cd /home/andrii/MyAIProjects/linux-wallpaperengine
   cmake --build build --parallel
   ```

2. Commit with `[RELEASE]` in the message (for changelog consistency):
   ```bash
   git commit -m "[RELEASE] v0.0.X: <summary of what changed>"
   ```

3. Run the release script with the new version tag:
   ```bash
   ./release.sh v0.0.X
   ```

   The script:
   - Builds the project (`cmake --build`)
   - Packages `build/output/` into `linux-wallpaperengine-X.X.X-linux64.tar.zst` (falls back to `.tar.gz`)
   - Strips all binaries
   - Copies the standalone `linux-wallpaperengine` binary as a legacy asset
   - Runs `gh release create vX.X.X ...` to publish on GitHub with auto-generated notes

---

## Full checklist

```
Reports
[ ] wall report list
[ ] Read each report, note wallpaper IDs and stderr patterns
[ ] Triage: wall bug vs engine bug (see table in Step 1)

Reproduce
[ ] Establish trigger + before/after for each bug

Fix wall  (if applicable)
[ ] Implement fix in bin/wall or bin/wall-gui
[ ] Verify manually
[ ] git commit -m "fix: ..."

Fix engine  (if applicable)
[ ] Implement fix in src/WallpaperEngine/...
[ ] cmake --build build --parallel  (must compile cleanly)
[ ] git commit -m "fix: ..."

Compatibility notes  (for every wallpaper tinkered with)
[ ] Add/update entry in _WALLPAPER_NOTES in bin/wall
[ ] Be explicit: partial fix, skipped rendering, open investigation, etc.
[ ] Reference engine version if a fix landed

Release wall  (if wall was changed)
[ ] Bump VERSION in bin/wall
[ ] git commit -m "[RELEASE] vX.Y.Z: ..." && git push
[ ] Confirm GitHub Actions created release

Release engine  (if engine was changed)
[ ] cmake --build build --parallel
[ ] git commit -m "[RELEASE] v0.0.X: ..."
[ ] ./release.sh v0.0.X
[ ] Confirm release published on GitHub
```
