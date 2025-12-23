# Project Context

## Purpose
Create a Project Zomboid Build 42 multiplayer-compatible mod that fixes broken leather crafting mechanics by adding context-menu based instant crafting for leather items on drying racks when players have leather/hides in their inventory.

## Tech Stack
- **Project Zomboid Build 42**: Game engine with Lua scripting (Kahlua 5.1)
- **PZMC Template**: Hybrid B41/B42 mod structure for compatibility
- **Lua 5.1**: Primary scripting language for game logic
- **Text-based recipes**: Item and recipe definitions in simple format
- **Steam Workshop**: Distribution platform for PZ mods

## Project Conventions

### Code Style
- **Lua conventions**: Follow PZ wiki examples and existing vanilla patterns
- **File naming**: kebab-case for mod components, clear descriptive names
- **Comments**: Document complex logic and vanilla API interactions
- **Error handling**: Graceful degradation with user feedback

### Architecture Patterns
- **Context Menu Hooking**: Use `OnFillWorldObjectContextMenu` event for drying rack interactions
- **Inventory Scanning**: Player inventory first, expand to containers later
- **Mod Structure**: Hybrid B41/B42 template using `42/` and `common/` folders
- **Separation of Concerns**: Logic in Lua, recipes in text files, items in text files

### Testing Strategy
- **Clean save testing**: Start new games to verify mod functionality
- **Multiplayer testing**: Verify B42 MP compatibility with drying rack interactions
- **macOS compatibility**: Test on target platform with PZ installation paths
- **Incremental testing**: Test each leather crafting recipe individually

### Git Workflow
- **Feature branches**: `feature/context-menu-crafting`, `feature/inventory-scanning`
- **Commit convention**: `feat: add context menu for leather crafting`  
- **Semantic versioning**: Follow PZ mod conventions (major.minor.patch)

## Domain Context

### Project Zomboid Modding B42
- **Build 42 unstable**: New crafting UI introduced, many vanilla recipes broken
- **Multiplayer focus**: Mod must work in B42 MP environment
- **Leather crafting issues**: Drying racks not functional in crafting UI, context menus needed
- **Mod structure**: Requires `mod.info`, `media/` folder, supports hybrid B41/B42

### Vanilla Game Systems
- **Drying racks**: World objects that normally process hides/leather over time
- **Crafting recipes**: Text-based definitions in `media/scripts/recipes.txt`
- **Item definitions**: Text-based definitions in `media/scripts/items.txt`
- **Context menus**: Hooked via Lua events, require player proximity and inventory items

### Community Standards
- **PZ wiki**: Authoritative source for modding information
- **Steam Workshop**: Primary distribution, requires workshop.txt and poster.png
- **PZMC template**: Community standard for hybrid version compatibility
- **OpenSpec methodology**: Spec-driven development with proposal, implementation, archive phases

## Important Constraints
- **B42 MP compatibility**: Must work in multiplayer unstable environment
- **Performance**: Minimal impact on game performance, efficient inventory scanning
- **Compatibility**: Avoid conflicts with existing leather/crafting mods
- **Save safety**: No save corruption risk, reversible installation
- **Steam Workshop**: Must meet workshop requirements (mod.info, poster, proper structure)

## External Dependencies
- **Project Zomboid B42**: Game installation required for testing
- **PZMC Template**: GitHub template for mod structure initialization
- **OpenSpec CLI**: Specification management and development workflow
- **Tavily MCP**: Web search capability for ongoing research and validation
- **PZ Wiki**: Documentation and API reference for modding patterns

### Key Resource Links
- **Modding Guide**: https://pzwiki.net/wiki/Modding
- **PZMC Template**: https://github.com/Project-Zomboid-Community-Modding/pzmc-template
- **Mod Structure**: https://pzwiki.net/wiki/Mod_structure
- **Lua API**: https://pzwiki.net/wiki/Lua_(API)
- **B42 Resources**: https://github.com/JBD-Mods/awesome-project-zomboid-build42-resources