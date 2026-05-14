## Leaps and Bounds

Leaps and Bounds is a 2D timed platformer built in Godot. The goal is to move through levels as quickly as possible using movement mechanics such as sprinting and dashing.

## Overview

This repository contains the full source code, scenes, scripts, and assets for the game. The main gameplay content is organized into scene and script folders, while supporting assets such as sprites, fonts, and imported resources are kept in their own separate directories.

## Engine / Requirements

- **Engine:** Godot Engine v4.6.1
- **Tested on:** macOS and Windows
- **Language/Scripting:** GDScript

No external package manager dependencies are required beyond the correct Godot version.

## How to Run the Project

  1. Clone the repository:
   ```bash
   git clone git@github.com:NMSU-CS-CS371/team-project-real-2dspeedrunner.git
   ```
       
  3. Open **Godot Engine**.
  
  4. Click **Import**.
  
  5. Select the 'project.godot' file in the root of the repository.
  
  6. Open the project.
  
  7. Run the project from the editor.

  The project starts from:

      - 'scenes/main_menu.tscn'

## How to Build / Export

This project uses Godot's built-in export system.

  1. Open the project in Godot.
  2. Go to **Project -> Export**.
  3. Choose an export preset.
  4. Export for your targeted platform.

### Export Notes

  - Export settings are stored in 'export_presets.cfg'.
  - The project has been tested on **macOS** and **Windows**.
  - Other export targets may be supported by Godot, but only macOS and Windows have been confirmed for this project.
  - Godot export templates may need to be installed through the editor before exporting.

## Controls

  - **Move:** 'W', 'A', 'S', 'D' or arrow keys
  - **Dash:** 'Ctrl'
  - **Sprint:** 'Shift'

## Repository Structure
```text
| ─ brackeys_platformer_assets/   # Imported asset pack resources
| ─ font2/                        # Fonts used by the project
| ─ homemade/                     # Custom teammate made assets
| ─ hunterssassets/               # Additional custom assets, named after the teammate that imported
| ─ scenes/                       # Main Godot scenes, some scene-local scripts, and shaders
| ─ scripts/                      # GDScript files for gameplay logic
| ─ .editorconfig                 # Editor formatting settings
| ─ .gitattributes                # Git attributes configuration
| ─ .gitignore                    # Git ignore rules
| ─ export_presets.cfg            # Godot export configuration
| ─ game_state.gd                 # Global game state script (uses autoload)
| ─ game_state.gd.uid             # Godot metadata for the script
| ─ icon.svg                      # Project icon
| ─ icon.svg.import               # Godot import metadata
| ─ levelroadmap.txt              # Design notes for level layout/theme planning
| ─ pixilart-drawing.png          # Image asset used in the project
| ─ pixilart-drawing.png.import   # Godot import metadata
| ─ project.godot                 # Main Godot project file
```

## Scenes Folder Summary

The 'scenes/' folder contains the playable, UI, and supporting scene files for the game. It includes files:

- `main_menu.tscn` — main menu scene and project entry point
- `game.tscn` — technically level1, but isn't updated, playable level scene
- `player.tscn` — player scene
- `level2.tscn` and `level3.tscn` — playable level scenes
- `level_select.tscn` — level selection screen
- `pause_menu.tscn` — pause menu scene
- `hud.tscn` — heads-up display
- `stopwatch.tscn` — timing system scene
- `finish.tscn`, `finishlvl2.tscn`, `finishlvl3.tscn` — level finish triggers
- `level_complete_screen.tscn`, `level_complete_screenlvl2.tscn`, `level_complete_screenlvl3.tscn` — level completion screens
- `Checkpoint.tscn` — checkpoint scene
- `blue_platform.tscn`, `blue_platform2.tscn` — platform scenes
- `killzone_2.tscn` — out-of-bounds or hazard scene, both are used intermediately within the levels
- `audio_stream_player_2d.tscn` — audio scene
- `pause_menu.gdshader` — shader used by the pause menu

The `scenes/` folder also contains one script directly inside the folder:

  - `checkpoint.gd`

## Scripts Folder Summary

The `scripts/` folder contains the main gameplay and menu logic. It includes scripts such as:

- `main_menu.gd` — menu logic
- `player.gd` — player movement and actions
- `pause_menu.gd` — pause system behavior
- `hud.gd` — HUD behavior
- `stopwatch.gd` — timer behavior
- `level_select.gd` — level selection logic
- `finish.gd`, `finishlvl_2.gd`, `finishlvl_3.gd` — finish condition logic
- `level_complete_screen.gd`, `level_complete_screenlvl_2.gd`, `level_complete_screenlvl_3.gd` — post-level result screens
- `killzone_2.gd` — hazard logic
- `tile_map.gd` — tilemap-related logic

## Important Files and Folders

### `project.godot`
The main Godot project file. This is the file used to import and open the project in Godot.

### `game_state.gd`
This script is configured as an **autoload**, which means it acts as a global singleton for shared game-state logic.

### `scenes/`
Contains the playable and non-playable scenes for the game, including the main menu, levels, UI, timer, pause menu, checkpoints, and completion screens.

### `scripts/`
Contains the GDScript files that define gameplay behavior and game systems.

### `levelroadmap.txt`
Contains level design notes and planning information. It was used to guide the team when designing level themes and layouts.

## Asset / License Information

Asset credit and license details are documented in the repository's license files:

- `LICENSE & CREDITS.txt`
- `License.txt`

These files include credit information for Brackeys-repackaged assets and additional third-party assets used in the game.

## Notes for Reviewers

If you are reviewing the repository for project structure, the main gameplay-related content is in:

  - `scenes/`
  - `scripts/`
  - `game_state.gd`

The other folders mostly contain imported assets, fonts, custom art, or project support files.

## Credits

Please see the license files in the repository for complete asset attribution and usage terms.

Highlights include:

- Brackeys-repackaged assets under **Creative Commons Zero (CC0)** with credits listed for original sprite, sound, music, and font contributors.
- ElvGames assets with usage permissions and credit requirements.

## Levels

### Level 1
- **Theme:** Sky Islands
- **Goal:** To give a player introduction to the game and provide them with an environment they can familiarize themselves with. 
- **Focus:** The level starts with some simple jumps, where the player learns about variable jumping. Then the level starts introducing moving platforms which the player tests their timings and application of movement. 

### Level 2
- **Theme:** Crystal Cave
- **Goal:** To give a player a space to explore the depth of the movement system and the importance of precision.
- **Focus:** The level starts with simple walljumping, and a few crystals (which kill the player). After a tight leap across a chasm, the rest of the level continues with tighter platforming and a very tight ending jump. There is a checkpoint after the chasm leap, as to skip the beginning introductory part.

### Level 3
- **Theme:** Crimson Abyss
- **Goal:** To give a player a final challenge combining moving platforms, deadly obstacles, and mastery of the movement system.
- **Focus:** The level is littered with spikes (and checkpoints) all throughout, along with many segments that offer alternative routes. A first visit would require a lot of care and caution, but after learning the routes to the level, level 3 offers the most skill expression out of all the levels.

## Known Issues

- Export has only been tested on macOS and Windows.
- Additional polish may still be needed for menu transitions and level balancing.

## Authors

- Hunter Morgan
- Emmanuel Medrano
- Brooklin James
- Victor Hannan

