
extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_lvl1_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_lvl2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level2.tscn")

func _on_lvl3_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level3.tscn")

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
