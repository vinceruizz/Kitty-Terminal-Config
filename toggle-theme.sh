#!/bin/sh
# Toggle between Hacker and Space themes for Kitty

KITTY_DIR="$HOME/.config/kitty"
CURRENT_THEME="$KITTY_DIR/current-theme.conf"
HACKER_THEME="$KITTY_DIR/themes/hacker.conf"
SPACE_THEME="$KITTY_DIR/themes/space.conf"

# Check which theme is currently active
if [ -L "$CURRENT_THEME" ]; then
    CURRENT=$(readlink "$CURRENT_THEME")
elif [ -f "$CURRENT_THEME" ]; then
    # Check content to determine theme
    if grep -q "background_image none" "$CURRENT_THEME" 2>/dev/null || grep -q "#00ff00" "$CURRENT_THEME" 2>/dev/null; then
        CURRENT="hacker"
    else
        CURRENT="space"
    fi
else
    CURRENT="none"
fi

# Toggle to the other theme
if echo "$CURRENT" | grep -q "hacker"; then
    ln -sf "$SPACE_THEME" "$CURRENT_THEME"
    echo "Switched to Space theme"
else
    ln -sf "$HACKER_THEME" "$CURRENT_THEME"
    echo "Switched to Hacker theme"
fi
