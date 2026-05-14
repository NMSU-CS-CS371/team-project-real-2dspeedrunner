# Scenes Folder

This folder contains the main Godot scenes used by **Leaps and Bounds**.

## Purpose

Scenes define the playable levels, menus, UI, reusable gameplay objects, and support systems used by the game.

## Current Scene Layout

- `audio_stream_player_2d.tscn` — audio (music) scene
- `blue_platform.tscn` — platform scene, used in levels
- `blue_platform2.tscn` — alternate platform scene, also used in levels
- `Checkpoint.tscn` — checkpoint scene, allows for checkpoint behavior
- `finish.tscn` — level finish trigger scene
- `finishlvl2.tscn` — level 2 finish scene
- `finishlvl3.tscn` — level 3 finish scene
- `game.tscn` — playable level 1, level 1 but it's named 'game' because it was the first level we made
- `hud.tscn` — heads-up display scene
- `killzone_2.tscn` — hazard zone scene
- `level_complete_screen.tscn` — completion screen for level 1
- `level_complete_screenlvl2.tscn` — completion screen for level 2
- `level_complete_screenlvl3.tscn` — completion screen for level 3
- `level_select.tscn` — level selection scene
- `level2.tscn` — playable level 2
- `level3.tscn` — playable level 3
- `main_menu.tscn` — project entry point and main menu
- `pause_menu.tscn` — pause menu scene
- `player.tscn` — player scene
- `stopwatch.tscn` — timer scene

## Other Files in This Folder

- `checkpoint.gd` — script stored directly inside the scenes folder
- `pause_menu.gdshader` — shader used for pause menu visuals
- imported resource metadata files such as `.uid` and `.import`

## Notes

These scenes are what make the baseline of the game. Levels either duplicate or slightly edit these scenes in order for them to use functionality. Everything was a duplicate of our first level (hence why its named 'game' and not level 1). 
