#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Repository URL
REPO_URL="https://github.com/vinceruizz/Kitty-Terminal-Config.git"
TMP_DIR="/tmp/kitty-config-install"

# Cleanup function
cleanup() {
  if [ -d "$TMP_DIR" ]; then
    info "Cleaning up temporary files..."
    rm -rf "$TMP_DIR"
  fi
}

# Set trap to cleanup on exit
trap cleanup EXIT

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
  MINGW* | MSYS* | CYGWIN*)
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
  if command -v kitty &>/dev/null; then
    info "Kitty is installed: $(kitty --version)"
  else
    warn "Kitty is not installed. Install it first:"
    case "$(uname -s)" in
    Linux*)
      if command -v apt &>/dev/null; then
        echo "  sudo apt install kitty"
      elif command -v pacman &>/dev/null; then
        echo "  sudo pacman -S kitty"
      elif command -v dnf &>/dev/null; then
        echo "  sudo dnf install kitty"
      else
        echo "  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
      fi
      ;;
    Darwin*)
      echo "  brew install --cask kitty"
      ;;
    MINGW* | MSYS* | CYGWIN*)
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

# Clone repository to temp directory
clone_repo() {
  info "Cloning repository to temporary directory..."

  # Remove existing temp directory if it exists
  if [ -d "$TMP_DIR" ]; then
    rm -rf "$TMP_DIR"
  fi

  git clone --depth 1 "$REPO_URL" "$TMP_DIR" || error "Failed to clone repository"
  info "Repository cloned successfully!"
}

# Warn and confirm overwrite
confirm_overwrite() {
  echo ""
  echo -e "${RED}=========================================${NC}"
  echo -e "${RED}  WARNING: This will OVERWRITE your${NC}"
  echo -e "${RED}  existing kitty configuration!${NC}"
  echo -e "${RED}=========================================${NC}"
  echo ""

  if [ -e "$CONFIG_DIR" ]; then
    warn "Existing config found at: $CONFIG_DIR"
    echo "This directory will be DELETED and replaced."
    echo ""
  fi

  read -p "Are you sure you want to continue? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Installation cancelled."
    exit 0
  fi
}

# Install the config
install_config() {
  # Remove existing config directory if it exists
  if [ -e "$CONFIG_DIR" ]; then
    info "Removing existing config..."
    rm -rf "$CONFIG_DIR"
  fi

  # Create parent directory if needed
  mkdir -p "$(dirname "$CONFIG_DIR")"

  # Copy config files
  info "Installing config to $CONFIG_DIR..."
  mkdir -p "$CONFIG_DIR"

  # Copy all config files (excluding git directory and install script)
  cp "$TMP_DIR/kitty.conf" "$CONFIG_DIR/"
  cp "$TMP_DIR/macos.conf" "$CONFIG_DIR/"
  cp "$TMP_DIR/linux.conf" "$CONFIG_DIR/"
  cp "$TMP_DIR/windows.conf" "$CONFIG_DIR/"

  # Copy themes directory
  if [ -d "$TMP_DIR/themes" ]; then
    cp -r "$TMP_DIR/themes" "$CONFIG_DIR/"
  fi

  # Copy toggle-theme script
  if [ -f "$TMP_DIR/toggle-theme.sh" ]; then
    cp "$TMP_DIR/toggle-theme.sh" "$CONFIG_DIR/"
    chmod +x "$CONFIG_DIR/toggle-theme.sh"
  fi

  # Create current-theme.conf symlink pointing to hacker theme as default
  ln -sf "$CONFIG_DIR/themes/hacker.conf" "$CONFIG_DIR/current-theme.conf"

  # Copy PowerShell profile if it exists
  if [ -f "$TMP_DIR/Microsoft.PowerShell_profile.ps1" ]; then
    cp "$TMP_DIR/Microsoft.PowerShell_profile.ps1" "$CONFIG_DIR/"
  fi

  info "Config installed successfully!"
}

# Main
main() {
  echo ""
  echo "========================================="
  echo "  Kitty Terminal Config Installer"
  echo "========================================="
  echo ""

  detect_os
  check_kitty
  confirm_overwrite
  clone_repo
  install_config

  echo ""
  info "Installation complete!"
  info "Restart kitty or press Ctrl+Shift+F5 to reload config."
  echo ""
}

main
