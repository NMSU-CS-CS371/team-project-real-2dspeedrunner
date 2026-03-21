extends CharacterBody2D

const MAX_SPEED = 200.0
const ACCELERATION = 800.0   # How fast you reach max speed
const FRICTION = 1000.0       # How fast you stop (higher = snappier stops)
const SKID_FRICTION = 1500.0 # Extra friction when reversing direction (the "skid")
const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		# Check if we're skidding (moving opposite to input)
		var is_skidding = sign(velocity.x) != sign(direction) and velocity.x != 0
		if is_skidding:
			velocity.x = move_toward(velocity.x, 0, SKID_FRICTION * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		# No input — apply friction to slow down
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
