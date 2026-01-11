#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect OS and set config directory
detect_os() {
    case "$(uname -s)" in
        Linux*)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                info "Detected Linux: $NAME"
            else
                info "Detected Linux"
            fi
            CONFIG_DIR="$HOME/.config/kitty"
            ;;
        Darwin*)
            info "Detected macOS"
            CONFIG_DIR="$HOME/.config/kitty"
            ;;
        MINGW*|MSYS*|CYGWIN*)
            info "Detected Windows (Git Bash/MSYS)"
            CONFIG_DIR="$APPDATA/kitty"
            ;;
        *)
            # Check for WSL
            if grep -qi microsoft /proc/version 2>/dev/null; then
                info "Detected WSL"
                CONFIG_DIR="$HOME/.config/kitty"
            else
                error "Unsupported operating system: $(uname -s)"
            fi
            ;;
    esac
}

# Check if kitty is installed
check_kitty() {
    if command -v kitty &> /dev/null; then
        info "Kitty is installed: $(kitty --version)"
    else
        warn "Kitty is not installed. Install it first:"
        case "$(uname -s)" in
            Linux*)
                if command -v apt &> /dev/null; then
                    echo "  sudo apt install kitty"
                elif command -v pacman &> /dev/null; then
                    echo "  sudo pacman -S kitty"
                elif command -v dnf &> /dev/null; then
                    echo "  sudo dnf install kitty"
                else
                    echo "  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
                fi
                ;;
            Darwin*)
                echo "  brew install --cask kitty"
                ;;
            MINGW*|MSYS*|CYGWIN*)
                echo "  Download from: https://github.com/kovidgoyal/kitty/releases"
                ;;
        esac
        echo ""
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Backup existing config
backup_config() {
    if [ -e "$CONFIG_DIR/kitty.conf" ]; then
        BACKUP="$CONFIG_DIR/kitty.conf.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Existing config found. Backing up to: $BACKUP"
        cp "$CONFIG_DIR/kitty.conf" "$BACKUP"
    fi
}

# Install the config
install_config() {
    # Create config directory if it doesn't exist
    mkdir -p "$CONFIG_DIR"

    # Ask user preference
    echo ""
    echo "Installation method:"
    echo "  1) Symlink (recommended - stays in sync with repo)"
    echo "  2) Copy (standalone copy)"
    read -p "Choose [1/2]: " -n 1 -r
    echo

    case $REPLY in
        2)
            info "Copying config to $CONFIG_DIR"
            cp "$SCRIPT_DIR/kitty.conf" "$CONFIG_DIR/kitty.conf"
            info "Config copied successfully!"
            ;;
        *)
            info "Creating symlink to $CONFIG_DIR"
            # Remove existing file/symlink
            rm -f "$CONFIG_DIR/kitty.conf"
            ln -s "$SCRIPT_DIR/kitty.conf" "$CONFIG_DIR/kitty.conf"
            info "Symlink created successfully!"
            ;;
    esac
}

# Main
main() {
    echo ""
    echo "========================================="
    echo "  Kitty Terminal Config Installer"
    echo "  Cyber Wave Theme"
    echo "========================================="
    echo ""

    detect_os
    check_kitty
    backup_config
    install_config

    echo ""
    info "Installation complete!"
    info "Restart kitty or press Ctrl+Shift+F5 to reload config."
    echo ""
}

main
