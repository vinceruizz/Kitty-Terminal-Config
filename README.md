# Kitty Terminal Config

A sleek, transparent Kitty terminal configuration featuring the **Cyber Wave** theme inspired by Warp terminal.

## Features

- Cyber Wave color scheme (dark teal with vibrant accent colors)
- Transparent background with blur effect
- Powerline-style tab bar
- Seamless macOS title bar integration
- AdwaitaMono Nerd Font

## Preview

- **Background**: Dark teal (#002633) with 85% opacity
- **Accent colors**: Cyan, magenta, green highlights
- **Tab bar**: Slanted powerline style with purple active tab

## Installation

### Prerequisites

Install Kitty terminal first:

**macOS**
```bash
brew install --cask kitty
```

**Ubuntu/Debian**
```bash
sudo apt install kitty
```

**Arch Linux**
```bash
sudo pacman -S kitty
```

**Windows**
```powershell
winget install kovidgoyal.kitty
```
Or download from [Kitty Releases](https://github.com/kovidgoyal/kitty/releases)

### Install Config

**macOS / Linux / WSL**
```bash
git clone https://github.com/vinceruizz/Kitty-Terminal-Config.git
cd Kitty-Terminal-Config
./install.sh
```

**Windows (Git Bash)**
```bash
git clone https://github.com/vinceruizz/Kitty-Terminal-Config.git
cd Kitty-Terminal-Config
./install.sh
```

**Manual Installation**
```bash
# macOS / Linux
cp kitty.conf ~/.config/kitty/kitty.conf

# Windows
cp kitty.conf %APPDATA%/kitty/kitty.conf
```

## Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+Shift+T` | New tab |
| `Ctrl+Shift+Q` | Close tab |
| `Ctrl+Shift+Right/Left` | Next/previous tab |
| `Ctrl+Shift+Enter` | New window (split) |
| `Ctrl+Shift+W` | Close window |
| `Ctrl+Shift+L` | Cycle layouts |
| `Ctrl+Shift+F5` | Reload config |
| `Ctrl+Shift+Equal/Minus` | Increase/decrease font size |

## Customization

Edit `kitty.conf` to adjust:

- `background_opacity` - Transparency (0.0 - 1.0)
- `background_blur` - Blur amount (0 - 64)
- `font_size` - Font size in points
- `background` - Background color

## Font

This config uses **AdwaitaMono Nerd Font**. Install it from [Nerd Fonts](https://www.nerdfonts.com/font-downloads).
