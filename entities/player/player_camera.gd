extends Camera2D

@onready var player_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"

@export var look_ahead_distance: float = 50.0
@export var look_ahead_speed: float = 5.0

func _process(delta: float) -> void:
	var facing: float
	
	if player_sprite.flip_h:
		facing = -1.0
	else:
		facing = 1.0
	
	var target_x = facing * look_ahead_distance
	
	position.x = lerpf(position.x, target_x, look_ahead_speed * delta)
