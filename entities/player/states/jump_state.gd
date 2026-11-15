extends State

func enter() -> void:
	entity.update_facing(Input.get_axis("move_left", "move_right"))
	entity.velocity.y = entity.jump_velocity
	entity.coyote_timer = 0.0
	entity.jump_buffer_timer = 0.0
	
	entity.player_sprite.play("jump")
	entity.squash_and_stretch(Vector2(0.75, 1.3), 0.15)
	entity.jump_dust.restart()

func physics_update(delta: float) -> String:
	if Input.is_action_just_released("jump") and entity.velocity.y < 0.0:
		entity.velocity.y *= entity.jump_cut_multiplier
	
	entity.velocity.y += entity.jump_gravity * delta 
	
	entity.handle_air_movement(delta)
	
	entity.move_and_slide()
	
	if entity.jump_buffer_timer > 0.0 and entity.get_wall_jump_dir() != 0.0:
		return "walljump"
	elif entity.can_dash():
		return "dash"
	elif entity.velocity.y >= 0.0:
		return "fall"
	else:
		return ""
