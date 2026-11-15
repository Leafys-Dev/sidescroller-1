extends State

func enter() -> void:
	entity.update_facing(Input.get_axis("move_left", "move_right"))
	entity.player_sprite.play("run")
	entity.run_dust.emitting = true


func exit() -> void:
	entity.run_dust.emitting = false

func physics_update(delta: float) -> String:
	var direction := Input.get_axis("move_left", "move_right")
	
	entity.update_facing(direction)
	
	var accel: float
	
	if direction == 0.0 or direction * entity.velocity.x < 0.0:
		accel = entity.ground_deceleration
	else:
		accel = entity.ground_acceleration
	
	entity.velocity.x = move_toward(entity.velocity.x, direction * entity.speed, accel * delta)
	
	entity.move_and_slide()
	
	if direction == 0.0 and entity.velocity.x == 0.0:
		return "idle"
	elif entity.can_dash():
		return "dash"
	elif entity.can_jump():
		return "jump"
	elif not entity.is_on_floor():
		return "fall"
	else: 
		return ""
	
	
