extends CharacterBody2D

const MAX_SPEED = 200.0
const ACCELERATION = 1000.0   # How fast you reach max speed
const FRICTION = 1200.0       # How fast you stop (higher = snappier stops)
const SKID_FRICTION = 1800.0 # Extra friction when reversing direction (the "skid")
const JUMP_VELOCITY = -300.0

# Jump tuning, 0.06-0.12
# Buffer time allows for 'delay' when pressing jump before landing
# i.e. it remembers when jump is pressed for a little bit to avoid missed inputs
const JUMP_BUFFER_TIME := 0.06
# Coyote time lets you jump a short amount after leaving the ground
# Allows jumping when leaving platforms, small amount of time to be 'fast'
const COYOTE_TIME := 0.06

# How much upward velocity is kept when the jump button is released early
# 0.25 (very snappy) - 0.5 (more forgiving) 
const JUMP_CUT_MULTIPLIER := 0.35

#Multiplier applied to gravity when falling
#Controls how fast the char. comes down after the jump apex
#1.2 (light) - 1.8 (very heavy / fast-fall) 
const FALL_GRAVITY_MULTIPLIER := 1.3

#Horizontal control while airborne, relative to ground control 
# 0.6 (momentum-focused) - 1.0 (very responsive) 
const AIR_CONTROL := 0.8 

#Stores how long a jump input should be remembered
var jump_buffer := 0.0
#Timer that allows the players to jump shortly after leaving the ground
var coyote_timer := 0.0


#ADDED NEW ACTIONS 
#jump - spcebar, W, up arrow
#move_left - left arrow, A
#move_right - right arrow, D
#also added crouch?, and double_jump? not implemented yet just added :D

#ADDED NEW JUMP TUNING
#changes jump input so it can take input better (pressing jump + movemnet is taken)

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	# Reads input here
	if Input.is_action_just_pressed("jump")  or Input.is_action_just_pressed("ui_up"):
		jump_buffer = JUMP_BUFFER_TIME
		

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		var gravity = get_gravity()
		if velocity.y > 0:
			gravity *= FALL_GRAVITY_MULTIPLIER 
		velocity += gravity * delta
		#velocity += get_gravity() * delta
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER
		
	var accel = ACCELERATION
	if not is_on_floor():
		accel *= AIR_CONTROL
		
	#NEW JUMP IMPLEMENTATION
	# Update coyote time 
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
	# Jump execution, buffer + coyote
	if jump_buffer > 0:
		jump_buffer -= delta
		
	if jump_buffer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer = 0
		coyote_timer = 0
	
	# Jump
	#if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		
	# Gets the input direction: -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flips the sprite to reflect direction =
	# Right direction 
	if direction > 0:
		animated_sprite.flip_h = false
	#left direction
	elif direction < 0:
		animated_sprite.flip_h = true

	
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
	
		#Play animations
	#if not moving -> idle animation, else -> run animation
	#if on floor then -> idle or run, else -> jump animation 
	if is_on_floor():
		if (abs(velocity.x)<0.0000001):
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
	# Applies the movement
