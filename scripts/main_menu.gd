extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_start2_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_options2_pressed() -> void:
	pass

func _on_quit2_pressed() -> void:
	get_tree().quit()
