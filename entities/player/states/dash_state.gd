extends State

func enter() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	
	entity.velocity.y = 0.0 
	
	if direction == 0.0:
		if entity.player_sprite.flip_h == true:
			direction = -1.0
		else:
			direction = 1.0
	
	entity.velocity.x = direction * entity.dash_speed 
	entity.has_dash = false
	entity.dash_timer = entity.dash_duration
	
	entity.update_facing(direction)
	entity.squash_and_stretch(Vector2(1.3, 0.75), 0.15)
	entity.jump_dust.restart()

func physics_update(delta: float) -> String:
	entity.dash_timer = max(entity.dash_timer - delta, 0.0)
	
	entity.move_and_slide()
	
	if entity.dash_timer <= 0.0:
		if entity.is_on_floor():
			return "run"
		else:
			return "fall"
	else:
		return ""

func exit() -> void:
	entity.dash_cooldown_timer = entity.dash_cooldown
	entity.velocity.x *= 0.5
