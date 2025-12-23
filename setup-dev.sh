#!/bin/bash
# setup-dev.sh - Creates a symlink to the mod in the Zomboid mods folder
# This allows for real-time code editing (requires Lua reload in-game)

PROJECT_ROOT="/Users/cduong/Projects/project-zomboid-mp-craft-leather-build-42"
ZOMBOID_MODS_DIR="$HOME/Zomboid/mods"
MOD_NAME="LeatherDryingRack"

echo "Setting up development environment..."

# 1. Create mods directory if it doesn't exist
mkdir -p "$ZOMBOID_MODS_DIR"

# 2. Remove existing link or directory
if [ -L "$ZOMBOID_MODS_DIR/$MOD_NAME" ]; then
    echo "Removing existing symlink..."
    rm "$ZOMBOID_MODS_DIR/$MOD_NAME"
elif [ -d "$ZOMBOID_MODS_DIR/$MOD_NAME" ]; then
    echo "Warning: $ZOMBOID_MODS_DIR/$MOD_NAME is a real directory. Moving to backup..."
    mv "$ZOMBOID_MODS_DIR/$MOD_NAME" "$ZOMBOID_MODS_DIR/${MOD_NAME}_backup_$(date +%s)"
fi

# 3. Create a detached dev folder to avoid modifying the git source mod.info
echo "Creating detached dev folder..."
DEV_PATH="$ZOMBOID_MODS_DIR/${MOD_NAME}_DEV"
rm -rf "$DEV_PATH"
mkdir -p "$DEV_PATH"

# Symlink all subfolders from source to dev folder
for item in "$PROJECT_ROOT/Contents/mods/$MOD_NAME"/*; do
    name=$(basename "$item")
    if [ "$name" != "mod.info" ]; then
        ln -s "$item" "$DEV_PATH/$name"
    fi
done

# Copy and modify mod.info specifically for dev
cp "$PROJECT_ROOT/Contents/mods/$MOD_NAME/mod.info" "$DEV_PATH/mod.info"
sed -i '' 's/^name=.*/name=[DEV] Leather Drying Rack Fix B42/' "$DEV_PATH/mod.info"
sed -i '' 's/^id=.*/id=ContextMenuCraftLeather_DEV/' "$DEV_PATH/mod.info"

echo "Setup complete!"
echo "The local mod will now appear as '[DEV] Leather Drying Rack Fix B42' with ID 'ContextMenuCraftLeather_DEV'."
echo "This detached setup allows you to keep your git source clean."
