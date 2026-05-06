extends Area2D

var activated := false

func _ready() -> void:
	print("Checkpoint ready:", name)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	print("Checkpoint touched by:", body.name)

	if activated:
		return

	if body.is_in_group("player") and body.has_method("set_checkpoint"):
		print("Checkpoint reached at:", global_position)
		body.set_checkpoint(global_position)
		activated = true
