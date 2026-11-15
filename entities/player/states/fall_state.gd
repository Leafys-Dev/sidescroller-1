extends State

func enter() -> void:
	entity.player_sprite.play("jump")

func physics_update(delta: float) -> String:
	entity.velocity.y += entity.fall_gravity * delta
	
	entity.handle_air_movement(delta)
	
	entity.move_and_slide()
	
	var direction := Input.get_axis("move_left", "move_right")
	var wall_normal := entity.get_wall_normal()
	
	if entity.can_jump():
		return "jump"
	elif entity.can_dash():
		return "dash"
	elif entity.jump_buffer_timer > 0.0 and entity.get_wall_jump_dir() != 0.0:
		return "walljump"
	elif entity.is_on_floor():
		return "land"
	elif entity.is_on_wall_only() and direction * wall_normal.x < 0.0:
		return "wallslide"
	else: 
		return ""
