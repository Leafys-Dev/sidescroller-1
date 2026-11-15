extends CharacterBody2D

@onready var wall_ray_left: RayCast2D = $WallRayLeft
@onready var wall_ray_right: RayCast2D = $WallRayRight

@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_dust: GPUParticles2D = $JumpDust
@onready var run_dust: GPUParticles2D = $RunDust

@export var speed: float = 300.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.2

@export var ground_acceleration: float = 3600.0
@export var ground_deceleration: float = 6000.0
@export var air_acceleration: float = 2800.0

# Wall Jump Var
@export var wall_slide_speed: float = 70.0
@export var wall_jump_push: float = 260.0
@export var wall_jump_lock_time: float = 0.12

@export var jump_cut_multiplier: float = 0.5
@export var jump_height: float = 70:
	set(value):
		jump_height = value
		get_current_gravity()
@export var jump_time_to_peak: float = 0.35:
	set(value):
		jump_time_to_peak = value
		get_current_gravity()
@export var jump_time_to_descent: float = 0.25:
	set(value):
		jump_time_to_descent = value
		get_current_gravity()

@export var coyote_time: float = 0.12
@export var jump_buffer: float = 0.12

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var wall_jump_lock_timer: float = 0.0
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0

var has_dash: bool = true

var squash_tween: Tween

var jump_velocity: float
var jump_gravity: float
var fall_gravity: float

func _ready() -> void:
	get_current_gravity()


func _physics_process(delta: float) -> void:
	# coyote timer.
	if not is_on_floor():
		coyote_timer -= delta
	else: 
		coyote_timer = coyote_time
		has_dash = true

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer
	else:
		jump_buffer_timer -= delta
	
	# Wall Jump Timer
	wall_jump_lock_timer = max(wall_jump_lock_timer - delta, 0.0)
	
	# Dash Timer
	dash_cooldown_timer = max(dash_cooldown_timer - delta, 0.0)
	

func can_dash() -> bool:
	return Input.is_action_just_pressed("dash") and has_dash and dash_cooldown_timer <= 0.0

func can_jump() -> bool:
	return jump_buffer_timer > 0.0 and coyote_timer > 0.0

func get_wall_jump_dir() -> float:
	if wall_ray_left.is_colliding():
		return 1.0
	elif wall_ray_right.is_colliding():
		return -1.0
	else:
		return 0.0

# Get Current Gravity
func get_current_gravity() -> void:
	jump_velocity = (-2 * jump_height) / jump_time_to_peak
	jump_gravity = (2 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
	fall_gravity = (2 * jump_height) / (jump_time_to_descent * jump_time_to_descent)

func handle_air_movement(delta: float, allow_flip: bool = true) -> void:
	if wall_jump_lock_timer > 0.0:
		return
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if allow_flip:
		update_facing(direction)
	
	velocity.x = move_toward(velocity.x, direction * speed, air_acceleration * delta)

func update_facing(direction: float) -> void:
	if direction > 0.0:
		player_sprite.flip_h = false
	elif direction < 0.0:
		player_sprite.flip_h = true

func squash_and_stretch(new_scale: Vector2, duration: float) -> void:
	if squash_tween:
		squash_tween.kill()
		
	squash_tween = create_tween()
	player_sprite.scale = new_scale
	
	squash_tween.tween_property(player_sprite, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
