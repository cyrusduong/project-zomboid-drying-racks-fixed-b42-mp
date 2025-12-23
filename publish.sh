#!/bin/bash
# Project Zomboid Mod Publishing Script
# This script uses steamcmd to upload the mod to the Steam Workshop.

PROJECT_ROOT="/Users/cduong/Projects/project-zomboid-mp-craft-leather-build-42"
VDF_PATH="$PROJECT_ROOT/workshop_build.vdf"
STEAM_USERNAME="keyreaper82"

echo "Preparing to publish DryingRacksFixedB42MP mod..."

# 0. Generate changelog from git history
# We look for all commits since the last time publish.sh was run (using a tag or tracking file)
LAST_PUBLISH_COMMIT_FILE="$PROJECT_ROOT/.last_publish_commit"
if [ -f "$LAST_PUBLISH_COMMIT_FILE" ]; then
    LAST_COMMIT=$(cat "$LAST_PUBLISH_COMMIT_FILE")
    # Get all commit subjects since the last publish, formatted with pipes as separators
    # (Steam Workshop changelogs don't always support true newlines via VDF, so we use a clear separator)
    CHANGELOG=$(git log "$LAST_COMMIT..HEAD" --oneline --pretty=format:"* %s" | paste -sd "," -)
    
    # If no new commits, use a default message
    if [ -z "$CHANGELOG" ]; then
        CHANGELOG="Minor updates and maintenance."
    fi
else
    CHANGELOG=$(git log -1 --pretty=format:"* %s")
fi

echo "Generating changelog: $CHANGELOG"

# Update the VDF file with the new changelog
# Use a temporary python snippet for safe string replacement in VDF (avoids sed escaping hell)
python3 -c "
import sys
content = open('$VDF_PATH').read()
new_line = '	\"changenote\"		\"$CHANGELOG\"'
import re
updated = re.sub(r'\"changenote\".*', new_line, content)
with open('$VDF_PATH', 'w') as f:
    f.write(updated)
"

# 1. Ensure we have the correct files ready for publishing
./install.sh

# 2. Upload to Steam Workshop
echo "Starting steamcmd upload..."
if steamcmd +login "$STEAM_USERNAME" +workshop_build_item "$VDF_PATH" +quit; then
    # Only update the tracking file if the upload succeeded
    git rev-parse HEAD > "$LAST_PUBLISH_COMMIT_FILE"
    echo "Publishing process complete! Tracked commit: $(cat $LAST_PUBLISH_COMMIT_FILE)"
else
    echo "Steam upload failed. Not updating last publish tracking."
    exit 1
fi
