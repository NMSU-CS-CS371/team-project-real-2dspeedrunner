extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	hide()



func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("ui_cancel") and !get_tree().paused:
		pause()
	


func _process(delta):
	testEsc()


func _on_resume2_pressed() -> void:
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	hide()
	pass # Replace with function body.


func _on_restart2_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_levels2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
	pass # Replace with function body.


func _on_quit2_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
