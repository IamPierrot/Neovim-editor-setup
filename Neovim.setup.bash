#!/usr/bin/env bash

# Args: <nvim_install_dir> <config_repo> <xdg_base_dir>
NVIM_PATH=${1:-"$HOME/.local/bin"}
CONFIG_REPO=${2:-"https://github.com/IamPierrot/My-Neovim-Config.git"}
XDG_BASE=${3:-"$HOME/.nvim"}

# Đặt XDG dirs
export XDG_CONFIG_HOME="$XDG_BASE/config"
export XDG_DATA_HOME="$XDG_BASE/data"
export XDG_STATE_HOME="$XDG_BASE/state"
export XDG_CACHE_HOME="$XDG_BASE/cache"

CONFIG_PATH="$XDG_CONFIG_HOME/nvim"

echo "=== Installing Neovim to $NVIM_PATH ==="
echo "Config: $CONFIG_PATH"
echo "Data:   $XDG_DATA_HOME/nvim"

# Cài Neovim
if command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y neovim git
elif command -v pacman &>/dev/null; then
    sudo pacman -Syu --noconfirm neovim git
elif command -v brew &>/dev/null; then
    brew install neovim git
else
    echo "Please install Neovim manually."
    exit 1
fi

# Clone config
rm -rf "$CONFIG_PATH"
git clone "$CONFIG_REPO" "$CONFIG_PATH"

echo "=== Done! Run with: XDG_CONFIG_HOME=$XDG_CONFIG_HOME nvim ==="
