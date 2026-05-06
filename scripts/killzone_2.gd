extends Area2D

@onready var timer: Timer = $Timer

var player_ref: Node2D = null
var triggered := false

func _on_body_entered(body: Node2D) -> void:
	if triggered:
		return

	if not body.is_in_group("player"):
		return

	if not body.has_method("die"):
		return

	triggered = true
	player_ref = body

	print("You died :(")
	Engine.time_scale = 0.5

	var collision_shape := body.get_node_or_null("CollisionShape2D")
	if collision_shape:
		collision_shape.set_deferred("disabled", true)

	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0

	if player_ref and is_instance_valid(player_ref):
		var collision_shape := player_ref.get_node_or_null("CollisionShape2D")
		if collision_shape:
			collision_shape.set_deferred("disabled", false)

		player_ref.die()

	player_ref = null
	triggered = false
