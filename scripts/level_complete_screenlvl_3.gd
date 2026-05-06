extends Control

@export var time_label: Label

func _ready() -> void:
	time_label.text = GameState.final_time



func _on_restart2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level3.tscn")
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass # Replace with function body.
