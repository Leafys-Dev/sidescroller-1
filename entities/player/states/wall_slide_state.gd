extends State

func enter() -> void:
	entity.player_sprite.play("jump")
	entity.player_sprite.flip_h = entity.get_wall_normal().x < 0.0

func physics_update(delta: float) -> String:
	entity.velocity.y = min(entity.velocity.y + entity.fall_gravity * delta, entity.wall_slide_speed)
	
	var direction := Input.get_axis("move_left", "move_right")
	
	entity.handle_air_movement(delta, false)
	entity.move_and_slide()
	
	if entity.jump_buffer_timer > 0.0:
		return "walljump"
	elif entity.is_on_floor():
		return "land"
	elif not entity.is_on_wall() or direction * entity.get_wall_normal().x >= 0.0:
		return "fall"
	else:
		return ""
