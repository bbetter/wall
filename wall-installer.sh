#!/usr/bin/env bash

set -e

REPO_RAW="https://raw.githubusercontent.com/bbetter/wall/main"

echo
echo "wall installer"
echo

########################################
# check yay
########################################

if ! command -v yay >/dev/null; then
  echo "ERROR: yay not found"
  echo "Install yay first: https://github.com/Jguer/yay"
  exit 1
fi

########################################
# dependencies
########################################

echo "Installing dependencies..."

yay -S --needed \
  jq \
  mpv \
  linux-wallpaperengine \
  fuzzel

########################################
# detect SteamLibrary
########################################

echo
echo "Searching for Steam libraries..."

declare -a LIBS

check_lib() {
  if [ -d "$1/steamapps/workshop/content/431960" ]; then
    LIBS+=("$1")
  fi
}

check_lib "$HOME/.local/share/Steam"
check_lib "$HOME/.steam/steam"
check_lib "$HOME/SteamLibrary"

for d in /media/*/*/SteamLibrary; do
  [ -d "$d" ] && check_lib "$d"
done

for d in /run/media/*/*/SteamLibrary; do
  [ -d "$d" ] && check_lib "$d"
done

########################################
# choose library
########################################

if [ "${#LIBS[@]}" -eq 0 ]; then

  echo
  echo "No SteamLibrary detected."
  read -rp "Enter SteamLibrary path manually: " STEAM_PATH

elif [ "${#LIBS[@]}" -eq 1 ]; then

  STEAM_PATH="${LIBS[0]}"
  echo "Found: $STEAM_PATH"

else

  echo
  echo "Multiple Steam libraries detected:"
  select STEAM_PATH in "${LIBS[@]}"; do
    break
  done

fi

STEAM_APPS="$STEAM_PATH/steamapps"

########################################
# install binaries
########################################

echo
echo "Installing wall tools..."

mkdir -p "$HOME/.local/bin"

for BIN in wall wall-picker wall-preview; do
  echo "  Downloading $BIN..."
  curl -sL "$REPO_RAW/bin/$BIN" -o "$HOME/.local/bin/$BIN"
  chmod +x "$HOME/.local/bin/$BIN"
done

########################################
# config
########################################

CONFIG_DIR="$HOME/.config/wall"
CONFIG_FILE="$CONFIG_DIR/config"

mkdir -p "$CONFIG_DIR"

echo "Writing config..."

echo "STEAM_LIB=$STEAM_APPS" >"$CONFIG_FILE"

########################################
# shell setup (PATH + alias)
# /usr/bin/wall conflict: a binary named
# 'wall' already exists on Linux systems.
# We alias it to our version in each shell.
########################################

setup_posix_shell() {
  local RC="$1"
  [ -f "$RC" ] || return

  if ! grep -q '\.local/bin' "$RC" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$RC"
  fi

  if ! grep -q 'alias wall=' "$RC" 2>/dev/null; then
    echo 'alias wall="$HOME/.local/bin/wall"' >>"$RC"
  fi
}

setup_posix_shell "$HOME/.bashrc"
setup_posix_shell "$HOME/.zshrc"

if [ -d "$HOME/.config/fish" ]; then
  FISH_CONFIG="$HOME/.config/fish/config.fish"
  touch "$FISH_CONFIG"
  if ! grep -q '\.local/bin' "$FISH_CONFIG" 2>/dev/null; then
    echo 'fish_add_path $HOME/.local/bin' >>"$FISH_CONFIG"
  fi
  if ! grep -q 'alias wall' "$FISH_CONFIG" 2>/dev/null; then
    echo "alias wall='$HOME/.local/bin/wall'" >>"$FISH_CONFIG"
  fi
fi

########################################
# autostart
########################################

echo
echo "Setting up autostart..."

HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

if [ -f "$HYPR_CONF" ]; then

  if ! grep -q 'exec-once.*wall' "$HYPR_CONF" 2>/dev/null; then
    echo "exec-once = wall random" >>"$HYPR_CONF"
    echo "  Added exec-once to hyprland.conf"
  else
    echo "  Hyprland autostart already present"
  fi

else

  AUTOSTART_DIR="$HOME/.config/autostart"
  mkdir -p "$AUTOSTART_DIR"

  cat >"$AUTOSTART_DIR/wall.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=wall
Exec=$HOME/.local/bin/wall random
X-KDE-Autostart-enabled=true
EOF

  echo "  Created $AUTOSTART_DIR/wall.desktop"

fi

########################################
# done
########################################

echo
echo "Installation complete!"
echo
echo "  SteamLibrary: $STEAM_PATH"
echo
echo "Commands:"
echo "  wall random"
echo "  wall list"
echo "  wall-picker"
echo
echo "Reload your shell:"
echo "  source ~/.bashrc              # bash"
echo "  source ~/.zshrc               # zsh"
echo "  source ~/.config/fish/config.fish  # fish"
echo
