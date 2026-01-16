#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
## Modified for swww

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# Function to set wallpaper
set_wallpaper() {
    local wallpaper="$1"

    # Convert to absolute path (expand ~)
    wallpaper="${wallpaper/#\~/$HOME}"

    if [ ! -f "$wallpaper" ]; then
        notify-send "Wallpaper Error" "File not found: $wallpaper"
        return 1
    fi

    # Set wallpaper with swww
    swww img "$wallpaper" --transition-type fade --transition-duration 1

    # Save current wallpaper
    echo "$wallpaper" > ~/.config/hypr/current_wallpaper

    notify-send "Wallpaper Changed" "$(basename "$wallpaper")"
}

# If argument provided, set that wallpaper directly
if [ -n "$1" ]; then
    set_wallpaper "$1"
    exit 0
fi

# Otherwise, show rofi menu for selection
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Error" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Get list of wallpapers
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort)

if [ ${#wallpapers[@]} -eq 0 ]; then
    notify-send "No Wallpapers" "Please add wallpapers to $WALLPAPER_DIR"
    exit 1
fi

# Create menu options (just filenames)
options=""
for wp in "${wallpapers[@]}"; do
    filename=$(basename "$wp")
    options="${options}${filename}\n"
done

# Show rofi menu
chosen=$(echo -e "$options" | rofi -dmenu -p "Select Wallpaper" \
    -theme ~/.config/rofi/theme.rasi \
    -theme-str 'element-icon {size: 0; margin: 0;}')

if [ -n "$chosen" ]; then
    # Find the full path of chosen wallpaper
    for wp in "${wallpapers[@]}"; do
        if [ "$(basename "$wp")" = "$chosen" ]; then
            set_wallpaper "$wp"
            break
        fi
    done
fi
