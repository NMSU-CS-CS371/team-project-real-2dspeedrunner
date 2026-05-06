extends CharacterBody2D

# --------------------
# Movement tuning
# --------------------
const ACCELERATION := 1000.0
const FRICTION := 1200.0
const SKID_FRICTION := 1800.0

const WALK_SPEED := 100.0
const SPRINT_SPEED := 200.0

# Jump
const JUMP_VELOCITY := -300.0
const JUMP_BUFFER_TIME := 0.06
const COYOTE_TIME := 0.06
const JUMP_CUT_MULTIPLIER := 0.35
const FALL_GRAVITY_MULTIPLIER := 1.3
const AIR_CONTROL := 0.8

# Level 1: no double jump yet
const MAX_JUMPS := 1
var jumps_left := MAX_JUMPS

# Wall jump (Level 1)
const WALL_JUMP_X := 220.0
const WALL_JUMP_Y := -300.0
const WALL_JUMP_LOCK_TIME := 0.08

# Dash
const DASH_SPEED := 450.0
const DASH_DURATION := 0.10
const DASH_COOLDOWN := 0.25
const DASH_STOPS_GRAVITY := true

const WALL_INTENT_TIME := 0.08
var wall_intent := 0.0

var is_dashing := false
var dash_time_left := 0.0
var dash_cooldown_left := 0.0
var can_dash := true
var dash_dir := 1

# Timers
var jump_buffer := 0.0
var coyote_timer := 0.0
var wall_jump_lock := 0.0

var max_speed := WALK_SPEED

# Cached wall normal from last slide
var cached_wall_normal := Vector2.ZERO

# --------------------
# Checkpoint / Respawn
# --------------------
var respawn_position: Vector2
var is_dead := false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprint_timer: Timer = $Timer


func _ready() -> void:
	respawn_position = global_position
	print("Initial respawn position:", respawn_position)
	print("In player group?:", is_in_group("player"))


func _unhandled_input(event: InputEvent) -> void:
	if is_dead:
		return

	# Buffer jump presses (works for both "jump" and "ui_up")
	if event.is_action_pressed("jump") or event.is_action_pressed("ui_up"):
		jump_buffer = JUMP_BUFFER_TIME


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# --------------------------------
	# Timers
	# --------------------------------
	if jump_buffer > 0.0:
		jump_buffer -= delta
	if dash_cooldown_left > 0.0:
		dash_cooldown_left -= delta
	if coyote_timer > 0.0:
		coyote_timer -= delta
	if wall_jump_lock > 0.0:
		wall_jump_lock -= delta

	# --------------------------------
	# Grounded rules (Level 1)
	# --------------------------------
	if is_on_floor():
		coyote_timer = COYOTE_TIME
		jumps_left = MAX_JUMPS
		can_dash = true

	# --------------------------------
	# Facing / input
	# --------------------------------
	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	var facing := -1 if animated_sprite.flip_h else 1
	
	if cached_wall_normal != Vector2.ZERO and direction != 0.0 and signf(direction) == -signf(cached_wall_normal.x):
		wall_intent = WALL_INTENT_TIME
	else:
		wall_intent = max(0.0, wall_intent - delta)

	# --------------------------------
	# Sprint
	# --------------------------------
	if Input.is_action_just_pressed("sprint"):
		max_speed = SPRINT_SPEED
		sprint_timer.start()

	# --------------------------------
	# Dash start
	# --------------------------------
	if Input.is_action_just_pressed("dash") and can_dash and dash_cooldown_left <= 0.0 and not is_dashing:
		var input_dir := direction
		var dir := facing
		if input_dir != 0.0:
			dir = sign(input_dir)
		start_dash(dir)

	# --------------------------------
	# Dash active
	# --------------------------------
	if is_dashing:
		dash_time_left -= delta
		velocity.x = dash_dir * DASH_SPEED
		if DASH_STOPS_GRAVITY:
			velocity.y = 0.0

		move_and_slide()
		_update_cached_wall_normal()

		if dash_time_left <= 0.0:
			end_dash()
		_play_anim()
		return

	# --------------------------------
	# Gravity
	# --------------------------------
	if not is_on_floor():
		var gravity := get_gravity()
		if velocity.y > 0.0:
			gravity *= FALL_GRAVITY_MULTIPLIER
		velocity += gravity * delta

	# Variable jump height
	if (Input.is_action_just_released("jump") or Input.is_action_just_released("ui_up")) and velocity.y < 0.0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	# --------------------------------
	# Jump execution
	# --------------------------------
	if jump_buffer > 0.0:
		var can_ground_jump := (is_on_floor() or coyote_timer > 0.0)

		var can_wall_jump := (
			not is_on_floor()
			and cached_wall_normal != Vector2.ZERO
			and wall_intent > 0.0
			and wall_jump_lock <= 0.0
		)

		if can_ground_jump and jumps_left > 0:
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1
			jump_buffer = 0.0
			coyote_timer = 0.0

		elif can_wall_jump:
			velocity.x = cached_wall_normal.x * WALL_JUMP_X
			velocity.y = WALL_JUMP_Y
			wall_jump_lock = WALL_JUMP_LOCK_TIME
			jump_buffer = 0.0

	# --------------------------------
	# Horizontal movement
	# --------------------------------
	var accel := ACCELERATION
	if not is_on_floor():
		accel *= AIR_CONTROL

	if direction != 0.0:
		var is_skidding: bool = (direction != 0.0 and velocity.x != 0.0 and velocity.x * direction < 0.0)
		if is_skidding:
			velocity.x = move_toward(velocity.x, 0.0, SKID_FRICTION * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * max_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	move_and_slide()
	_update_cached_wall_normal()
	_play_anim()


func start_dash(dir: int) -> void:
	is_dashing = true
	can_dash = false
	dash_time_left = DASH_DURATION
	dash_cooldown_left = DASH_COOLDOWN
	dash_dir = dir

	if DASH_STOPS_GRAVITY:
		velocity.y = 0.0


func end_dash() -> void:
	is_dashing = false


func _on_timer_timeout() -> void:
	max_speed = WALK_SPEED


func _update_cached_wall_normal() -> void:
	if is_on_wall() and not is_on_floor():
		cached_wall_normal = get_wall_normal()
	else:
		cached_wall_normal = Vector2.ZERO


func _play_anim() -> void:
	if is_dead:
		return

	if is_on_floor():
		if abs(velocity.x) < 0.01:
			animated_sprite.play("idle_2")
		else:
			animated_sprite.play("walk_2")
	else:
		if velocity.y < 0.0:
			animated_sprite.play("jump_2")
		else:
			animated_sprite.play("fall_2")


# --------------------
# Checkpoint / Respawn functions
# --------------------
func set_checkpoint(pos: Vector2) -> void:
	respawn_position = pos
	print("New respawn position set to: ", respawn_position)


func respawn() -> void:
	global_position = respawn_position
	velocity = Vector2.ZERO
	is_dead = false
	is_dashing = false
	jump_buffer = 0.0
	coyote_timer = 0.0
	wall_jump_lock = 0.0
	cached_wall_normal = Vector2.ZERO
	animated_sprite.play("idle_2")


func die() -> void:
	if is_dead:
		return

	is_dead = true
	print("Respawn at: ", respawn_position)

	velocity = Vector2.ZERO
	animated_sprite.play("damage_2")
	await animated_sprite.animation_finished

	animated_sprite.play("dead_2")
	await animated_sprite.animation_finished

	respawn()
