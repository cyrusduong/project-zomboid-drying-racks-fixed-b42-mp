#!/bin/bash
# Project Zomboid Mod Publishing Script
# This script uses steamcmd to upload the mod to the Steam Workshop.

PROJECT_ROOT="/Users/cduong/Projects/project-zomboid-mp-craft-leather-build-42"
VDF_PATH="$PROJECT_ROOT/workshop_build.vdf"
STEAM_USERNAME="keyreaper82"

echo "Preparing to publish LeatherDryingRack mod..."

# 1. Sync latest changes to the Workshop directory first
./install.sh

# 2. Upload to Steam Workshop
echo "Starting steamcmd upload..."
steamcmd +login "$STEAM_USERNAME" +workshop_build_item "$VDF_PATH" +quit

echo "Publishing process complete!"
