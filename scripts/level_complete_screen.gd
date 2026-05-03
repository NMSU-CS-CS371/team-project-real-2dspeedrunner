extends Control

@export var time_label: Label

func _ready() -> void:
	time_label.text = GameState.final_time

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_next_level_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
