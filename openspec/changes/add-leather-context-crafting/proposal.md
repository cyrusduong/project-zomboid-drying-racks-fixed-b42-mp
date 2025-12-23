# Change: Add Leather Context Menu Crafting

## Why
Project Zomboid Build 42 introduced a new crafting UI system that broke existing leather drying rack functionality. Players cannot process leather/hides through vanilla means due to UI recognition issues and broken recipe mechanics. This mod restores leather crafting capability through context menu interactions when players have appropriate materials in inventory.

## What Changes
- Add context menu options to drying racks for instant leather crafting
- Implement inventory scanning to detect leather/hides availability
- Create instant crafting recipes for leather items (armor, components)
- Override broken vanilla drying rack functionality with working alternatives
- Add proper error handling and user feedback

## Impact
- Affected specs: crafting
- Affected code: Lua scripts, recipe definitions
- Breaking changes: None (adds new capability without removing vanilla features)