extends State

func enter() -> void:
	entity.player_sprite.play("idle")

func physics_update(delta: float) -> String:
	entity.velocity.x = move_toward(entity.velocity.x, 0.0, entity.ground_deceleration * delta)
	
	if not entity.is_on_floor():
		entity.velocity.y += entity.fall_gravity * delta
	
	entity.move_and_slide()
	
	var direction := Input.get_axis("move_left", "move_right")
	if entity.can_dash():
		return "dash"
	elif direction != 0.0:
		return "run"
	elif entity.can_jump():
		return "jump"
	elif not entity.is_on_floor():
		return "fall"
	else:
		return ""
	
