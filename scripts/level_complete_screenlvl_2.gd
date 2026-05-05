extends Control

@export var time_label: Label

func _ready() -> void:
	time_label.text = GameState.final_time

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level2.tscn")


func _on_next_level_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level3.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
