extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_lvl1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	pass # Replace with function body.


func _on_lvl2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level2.tscn")
	pass # Replace with function body.


func _on_lvl3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level3.tscn")
	pass # Replace with function body.


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass # Replace with function body.
