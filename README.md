# Context Menu Craft Leather Fix - Build 42 MP

A Project Zomboid mod that fixes broken leather crafting mechanics by adding context menu options to drying racks for instant processing of wet furred leather into dried leather.

> **Note**: This is a temporary fix mod intended to restore leather crafting functionality until the official crafting system is fully implemented in the base game.

## Description

This mod addresses the leather crafting issues introduced in Project Zomboid Build 42 where the vanilla drying rack system became partially broken. Instead of relying on the traditional time-based drying mechanics, this mod provides instant leather processing through intuitive context menu interactions.

### Key Features

- **Instant Leather Processing**: Right-click any drying rack to instantly dry wet furred leather
- **Comprehensive Leather Support**: Works with all 18 wet furred leather types from vanilla
- **Smart Rack Validation**: Proper size compatibility checking (small, medium, large racks)
- **Multiplayer Compatible**: Full B42 multiplayer support with proper inventory synchronization
- **Type-Safe Implementation**: Built with EmmyLua type checking for reliability

## Supported Leather Types

### Small Leather (11 types)
- Rabbit, Rabbit Grey, Raccoon Grey
- Piglet Landrace, Piglet Black, Fawn, Lamb  
- Calf Angus, Calf Holstein, Calf Simmental
- Crude Small

### Medium Leather (4 types)
- Pig Landrace, Pig Black, Sheep
- Crude Medium

### Large Leather (5 types)
- Deer, Cow Angus, Cow Holstein, Cow Simmental
- Crude Large

## Installation

### Manual Installation
1. Download the mod from [Steam Workshop] (placeholder link)
2. Extract to your Zomboid Workshop directory:
   - **Windows**: `C:\Users\[username]\Zomboid\Workshop\LeatherDryingRack\`
   - **Mac**: `~/Zomboid/Workshop/LeatherDryingRack/`
   - **Linux**: `~/.local/share/ProjectZomboid/Workshop/LeatherDryingRack/`

The extracted structure should be:
```
LeatherDryingRack/
└── Contents/
    └── mods/
        └── LeatherDryingRack/
            ├── mod.info
            ├── .emmyrc.json
            └── media/
                └── lua/
                    ├── client/
                    └── shared/
```

When installed via Steam Workshop, this structure is created automatically.
3. Launch Project Zomboid
4. Click "Mods" in the main menu
5. Find "Context Menu Craft Leather Fix - Build 42 MP" and enable it
6. Start your game and enjoy instant leather crafting!

## Usage

1. **Obtain Drying Racks**: Craft or purchase vanilla drying racks (Simple, Medium, or Large)
2. **Get Wet Leather**: Hunt and butcher animals to obtain wet furred leather
3. **Process Leather**: 
   - Stand within 2 tiles of a drying rack
   - Ensure wet leather is in your inventory
   - Right-click on the drying rack
   - Select "Dry Leather" from the context menu
   - Choose the specific leather type you want to process
4. **Instant Result**: The leather is instantly dried and added to your inventory

## Compatibility

### Game Version
- **Required**: Project Zomboid Build 42 (41.78.16+)
- **Multiplayer**: Full B42 multiplayer support
- **Lua Version**: Lua 5.4

### Mod Compatibility
- **Standalone**: Works with existing vanilla drying racks
- **Non-Intrusive**: No modifications to core game files
- **Safe**: Compatible with existing save files
- **Multi-Mod**: Works alongside other crafting and leather mods

## Technical Implementation

### Architecture
The mod uses a clean, event-driven architecture:
- **Context Menu Handler**: Hooks into `Events.OnFillWorldObjectContextMenu`
- **Inventory Scanner**: Detects wet leather types in player inventory
- **Size Validator**: Ensures proper rack compatibility
- **Instant Processor**: Handles immediate item transformation

### Type Safety
Built with **PZ-Umbrella** types for enhanced development experience:
- Full EmmyLua type annotations
- Parameter and return type validation
- IDE IntelliSense support
- Runtime error prevention

### File Structure
```
Contents/mods/LeatherDryingRack/
├── mod.info                              # Mod metadata
├── .emmyrc.json                         # EmmyLua configuration
└── media/lua/
    ├── client/
    │   ├── ISLeatherDryingRackMenu.lua    # Context menu implementation
    │   └── tests/
    │       ├── ISLeatherDryingRackTests.lua    # Test suite
    │       └── ValidateMod.lua               # Validation script
    └── shared/
        └── LeatherDryingRackData.lua         # Shared data utilities
```

**Project Structure:**
```
project-zomboid-mp-craft-leather-build-42/
├── Contents/mods/LeatherDryingRack/     # Steam Workshop mod files
├── Umbrella/                           # PZ-Umbrella types (submodule)
├── openspec/                           # Development specifications
├── README.md                           # User documentation
└── IMPLEMENTATION_COMPLETE.md          # Technical documentation
```

## Development

This mod was developed using the PZ-Umbrella framework for enhanced type safety and development experience. The umbrella types provide comprehensive API documentation and type checking for Project Zomboid Lua development.

### Build Requirements
- Project Zomboid Build 42
- EmmyLua IDE plugin (recommended)
- PZ-Umbrella types (included as submodule)

## Support

For issues, suggestions, or contributions:
- [Steam Workshop Comments] (placeholder link)
- [GitHub Issues] (placeholder link)

## License

This mod is released under the same terms as Project Zomboid modding community standards.
