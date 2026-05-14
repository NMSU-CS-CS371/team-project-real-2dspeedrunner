# Scripts Folder

This folder contains the primary GDScript logic for **Leaps and Bounds**.

## Purpose

These scripts control gameplay systems, menus, timers, hazards, level completion, and the player.

## Current Script Layout

- `finish.gd` — level 1 finish condition logic
- `finishlvl_2.gd` — level 2 finish logic
- `finishlvl_3.gd` — level 3 finish logic
- `hud.gd` — HUD logic
- `killzone_2.gd` — killzone logic
- `level_complete_screen.gd` — level 1 completion screen logic
- `level_complete_screenlvl_2.gd` — level 2 completion screen logic
- `level_complete_screenlvl_3.gd` — level 3 completion screen logic
- `level_select.gd` — level select menu behavior
- `main_menu.gd` — main menu behavior
- `pause_menu.gd` — pause system behavior
- `player.gd` — player movement and action logic
- `stopwatch.gd` — timer logic
- `tile_map.gd` — tilemap-related logic

## Related Global Script

The repository root also contains `game_state.gd`, which is configured as an **autoload** and provides shared game-state access across scenes.

## Notes

If you are reviewing game logic, this is the main folder to inspect alongside `game_state.gd`.
This folder alongside `game_state.gd` shows the game logic that went inside of the game. All of this logic is used and interacts with each other to produce our levels. I think most of it is self explanatory, just based off of the names. 
