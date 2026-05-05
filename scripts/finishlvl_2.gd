extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var stopwatch := get_tree().get_first_node_in_group("stopwatch") as Stopwatch
		GameState.final_time = stopwatch.time_to_String()
		get_tree().change_scene_to_file("res://scenes/level_complete_screenlvl2.tscn")
