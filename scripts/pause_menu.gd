extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	$AnimationPlayer.play("RESET")
	hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func resume():
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	hide()

func _on_resume2_pressed() -> void:
	resume()

func _on_restart2_pressed() -> void:
	get_tree().paused = false
	hide()
	get_tree().reload_current_scene()

func _on_levels2_pressed() -> void:
	get_tree().paused = false
	hide()
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")

func _on_quit2_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
