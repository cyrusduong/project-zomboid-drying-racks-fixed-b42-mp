# Feedback Session 1: Prompting & Process Reflections

## Summary
This session was an excellent example of iterative mod development for Project Zomboid Build 42. We successfully transitioned from a basic "instant-click" fix to a polished, immersive "Timed Action" mod with sophisticated rack detection.

## Suggestions for Future Prompting (Improving Clarity & Shift-Left)

### 1. The "Starting State" Snapshot
**Pitfall**: Sometimes we spent cycles re-discovering that B42 entities return `NONE` for `getFullType`.
**Improvement**: When starting a new session or a major task, explicitly state "Known Technical Gotchas" in the first prompt. 
*Example*: "Remember: B42 drying racks use `crafted_05` sprites and often have `NONE` as their full type; we must detect them by name or sprite."

### 2. Identifying Implementation Early (Shift-Left)
**Positive**: You identified `HaloTextHelper` as the right tool for feedback early on.
**Improvement**: If you have a specific PZ API or helper in mind (like `luautils`, `ISTimedActionQueue`, or `HaloTextHelper`), mention it in the initial requirement. This prevents the model from defaulting to older or less-optimal patterns (like `player:Say()`).

### 3. Structural Constraints
**Positive**: The project uses a specific `42/media/lua` structure.
**Pitfall**: The AI might try to place files in `media/lua` (legacy) unless reminded.
**Improvement**: Mention the target version early: "This is a Build 42 mod using the `42/` subfolder structure."

## Pitfalls and Positives of the Current Plan

### Positives
- **Immersive Logic**: Moving to Timed Actions makes the mod feel like part of vanilla B42 rather than a "cheat" fix.
- **Robust Detection**: Using name-based, sprite-based, and coordinate-based filtering makes the mod compatible with both vanilla and modded racks.
- **Stealth-First**: Using HaloText instead of `Say()` respects the game's survival mechanics (noise management).

### Pitfalls
- **Multiplayer Desync**: While we added `sendAddItemToContainer`, B42's new Item/Component system is still evolving. We should monitor if rack "ownership" or "usage" states need to be locked while an action is in progress to prevent item duplication in high-latency MP environments.
- **Tooltip Limits**: We discovered `\n\n` doesn't work. The game UI is very picky about tags like `<LINE>`.

## Starting Context Assessment
The provided starting context (`mod.info`, existing structure, and `install.sh`) was **excellent**. Having the `install.sh` script specifically allowed for a rapid "implement -> sync -> verify" loop, which is critical for PZ modding where symlinks often fail on macOS.

---
*End of Feedback*
