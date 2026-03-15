#!/usr/bin/env bash

set -e

echo
echo "Steam Wallpaper Installer"
echo

########################################
# check yay
########################################

if ! command -v yay >/dev/null; then
    echo "ERROR: yay not found"
    echo "Install yay first."
    exit 1
fi

########################################
# dependencies
########################################

echo "Installing dependencies..."

yay -S --needed \
    jq \
    mpvpaper \
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

    read -p "Enter SteamLibrary path manually: " STEAM_PATH

elif [ "${#LIBS[@]}" -eq 1 ]; then

    STEAM_PATH="${LIBS[0]}"
    echo "Found SteamLibrary:"
    echo "  $STEAM_PATH"

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

cp bin/wall "$HOME/.local/bin/wall"
cp bin/wall-picker "$HOME/.local/bin/wall-picker"
cp bin/wall-preview "$HOME/.local/bin/wall-preview"

chmod +x "$HOME/.local/bin/wall"
chmod +x "$HOME/.local/bin/wall-picker"
chmod +x "$HOME/.local/bin/wall-preview"

########################################
# config
########################################

CONFIG_DIR="$HOME/.config/wall"
CONFIG_FILE="$CONFIG_DIR/config"

mkdir -p "$CONFIG_DIR"

echo "Writing config..."

echo "STEAM_LIB=$STEAM_APPS" > "$CONFIG_FILE"

########################################
# KDE autostart
########################################

AUTOSTART_DIR="$HOME/.config/autostart"
AUTOSTART_FILE="$AUTOSTART_DIR/wall.desktop"

mkdir -p "$AUTOSTART_DIR"

cat > "$AUTOSTART_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Steam Wallpaper
Exec=wall random
X-KDE-Autostart-enabled=true
EOF

########################################
# PATH
########################################

if ! grep -q ".local/bin" "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

########################################
# fix /usr/bin/wall conflict
########################################

if ! grep -q 'alias wall=' "$HOME/.bashrc" 2>/dev/null; then
    echo 'alias wall="$HOME/.local/bin/wall"' >> "$HOME/.bashrc"
fi

########################################
# done
########################################

echo
echo "Installation complete!"
echo
echo "SteamLibrary:"
echo "  $STEAM_PATH"
echo
echo "Commands:"
echo
echo "  wall random"
echo "  wall list"
echo "  wall-picker"
echo
echo "Recommended shortcut:"
echo
echo "  Command: wall-picker"
echo "  Shortcut: Meta + Shift + ."
echo
echo "Restart terminal or run:"
echo
echo "  source ~/.bashrc"
echo

