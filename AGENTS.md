<!-- OPENSPEC:START -->
# OpenSpec Instructions

These instructions are for AI assistants working in this project.

Always open `@/openspec/AGENTS.md` when the request:
- Mentions planning or proposals (words like proposal, spec, change, plan)
- Introduces new capabilities, breaking changes, architecture shifts, or big performance/security work
- Sounds ambiguous and you need the authoritative spec before coding

Use `@/openspec/AGENTS.md` to learn:
- How to create and apply change proposals
- Spec format and conventions
- Project structure and guidelines

Keep this managed block so 'openspec update' can refresh the instructions.

<!-- OPENSPEC:END -->

# Project Zomboid Mod Development Instructions

## Local Testing Setup

When working on Project Zomboid mods, follow this setup for local testing:

### Required Directory Structure
The workshop uploader and game engine require specific structure:

```
~/Zomboid/Workshop/LeatherDryingRack/
└── Contents/                   # All mod files must be inside this
    └── mods/
        └── LeatherDryingRack/
            ├── mod.info         # Mod metadata (nested only)
            ├── preview.png      # Workshop thumbnail (nested only)
            ├── .emmyrc.json    # EmmyLua configuration
            └── 42/
                └── media/
                    └── lua/
                        ├── client/
                        ├── shared/
                        └── tests/
```

### Installation Commands
```bash
# Remove any existing installation
rm -rf ~/Zomboid/Workshop/LeatherDryingRack

# Copy Contents folder (workshop uploader requirement)
cp -r /path/to/project/Contents ~/Zomboid/Workshop/LeatherDryingRack
```

### Critical Constraints
- **No symlinks**: Workshop uploader and game engine don't support symlinks
- **Nested only**: `mod.info` and `preview.png` exist only in nested location (per B42 standard)
- **Contents folder**: Workshop uploader requires ALL files inside `Contents/`
- **Build 42 structure**: Use `42/media/lua/` for Build 42 compatibility

### Testing Workflow
1. Edit files in project source (`/path/to/project/`)
2. Run installation commands to copy to workshop directory
3. Launch Project Zomboid
4. Enable mod in mods menu
5. Test changes in-game

### Workshop Upload Requirements
- Choose the `LeatherDryingRack` folder containing `Contents/` subfolder
- Workshop uploader validates that `Contents/` folder exists
- All files must be inside `Contents/` for proper upload

This ensures compatibility with both local testing and Steam Workshop distribution.