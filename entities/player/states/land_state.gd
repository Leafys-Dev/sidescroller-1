extends State

func enter() -> void:
	entity.update_facing(Input.get_axis("move_left", "move_right"))
	entity.player_sprite.play("land")
	entity.squash_and_stretch(Vector2(1.3, 0.75), 0.12)
	entity.jump_dust.restart()

func physics_update(delta: float) -> String:
	var direction := Input.get_axis("move_left", "move_right")
	
	entity.velocity.x = move_toward(entity.velocity.x, 0.0, entity.ground_deceleration * delta)
	
	entity.move_and_slide()
	
	if entity.can_jump():
		return "jump"
	elif direction != 0.0:
		return "run"
	elif not entity.player_sprite.is_playing():
		return "idle"
	else: 
		return ""
