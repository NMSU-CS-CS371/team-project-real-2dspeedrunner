extends Area2D

@onready var timer: Timer = $Timer

#Function is used when character enters killzone
func _on_body_entered(body: Node2D) -> void:
	#Prints out msg 'you died'
	print("You died :(")
	#Change to half speed 
	Engine.time_scale = 0.5
	#Removes CollisionShape2d from body (player) so it falls through the map
	body.get_node("CollisionShape2D").queue_free()
	#starts a timer, when it finishes calls other function
	timer.start()
	pass # Replace with function body.

#Function is used when timer runs out from prev. function
func _on_timer_timeout() -> void:
	#Sets it back to original speed
	Engine.time_scale = 1
	#Reloads the scene and restarts the game
	get_tree().reload_current_scene()
	pass # Replace with function body.
