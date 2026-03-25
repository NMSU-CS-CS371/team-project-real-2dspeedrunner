extends CharacterBody2D

const MAX_SPEED = 200.0
const ACCELERATION = 800.0   # How fast you reach max speed
const FRICTION = 1000.0       # How fast you stop (higher = snappier stops)
const SKID_FRICTION = 1500.0 # Extra friction when reversing direction (the "skid")
const JUMP_VELOCITY = -300.0

#ADDED NEW ACTIONS 
#jump - spcebar, W, up arrow
#move_left - left arrow, A
#move_right - right arrow, D
#also added crouch?, and double_jump? not implemented yet just added :D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Gets the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flips the sprite to reflect direction =
	# Right direction 
	if direction > 0:
		animated_sprite.flip_h = false
	#left direction
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#Play animations
	#if not moving -> idle animation, else -> run animation
	#if on floor then -> idle or run, else -> jump animation 
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	# Applies the movement
	
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
