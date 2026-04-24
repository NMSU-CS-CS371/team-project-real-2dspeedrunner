extends CharacterBody2D

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
var walk_speed=100
var max_speed = 100.0
var sprint_speed=200

#Dash var and constant
const DASH_SPEED := 450.0 #tune: 350-700
const DASH_DURATION := 0.10 #tune: 0.08-0.16
const DASH_COOLDOWN := 0.25 #cooldown 
const DASH_STOPS_GRAVITY := true #true = "straight dash"

var is_dashing := false
var dash_time_left := 0.0
var dash_cooldown_left := 0.0
var can_dash := true #reset when you touch ground (1 dash per airtime)
var dash_dir := 1 #-1 left, 1 right

#double jump var constants
const MAX_JUMPS := 2
const DOUBLE_JUMP_VELOCITY := -280.0 #can be same as JUMP_VELOCITY
var jumps_left := MAX_JUMPS

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
	# Dash timer/reset
	if is_on_floor():
		can_dash = true #remove if want cooldown-only dashing
	if dash_cooldown_left > 0.0:
		dash_cooldown_left -= delta
	#Decide facing direction from sprite flip
	var facing := 1
	if animated_sprite.flip_h:
		facing = -1 
	#Dash start input 
	if Input.is_action_just_pressed("dash") and can_dash and dash_cooldown_left <= 0.0 and not is_dashing:
		#Use movemnt input if held, otherwise dash facing direction 
		var input_dir := Input.get_axis("move_left", "move_right")
		var dir := facing
		if input_dir != 0:
			dir = sign(input_dir)
		start_dash(dir)
	#Dash active, override normal movement
	if is_dashing:
		dash_time_left -= delta
		velocity.x = dash_dir * DASH_SPEED
		if DASH_STOPS_GRAVITY:
			velocity.y = 0.0
		move_and_slide()
		#IMPLEMENTED BUT NOT APPLIED
		#animated_sprite.play("dash")
		if dash_time_left <= 0.0:
			end_dash()
		return
	#sprint
	if Input.is_action_pressed("sprint"):
		max_speed=sprint_speed
		get_node("Timer").start()
		print("begin sprinting")
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
		jumps_left = MAX_JUMPS 
	else:
		coyote_timer -= delta
	# Jump execution, buffer + coyote
	if jump_buffer > 0:
		jump_buffer -= delta
		#Can jumpif: coyote is still valid (ground jump) or we still have jumps remaining
		if coyote_timer > 0 or jumps_left > 0: 
			var use_velocity := JUMP_VELOCITY 
			#Slightly weaker/stronger second jump 
			if coyote_timer <= 0: #means we are truly in the air (not coyote)
				use_velocity = DOUBLE_JUMP_VELOCITY
			velocity.y = use_velocity 
			jumps_left -= 1
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
			velocity.x = move_toward(velocity.x, direction * max_speed, ACCELERATION * delta)
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

func start_dash(dir: int) -> void:
	is_dashing = true
	can_dash = false
	dash_time_left = DASH_DURATION 
	dash_cooldown_left = DASH_COOLDOWN
	dash_dir = dir
	
	#Kills vertical speed so dash is clean
	if DASH_STOPS_GRAVITY:
		velocity.y = 0
		
func end_dash() -> void:
	is_dashing = false

func _on_timer_timeout() -> void:
	max_speed=walk_speed
	print("tired")
	pass # Replace with function body.
