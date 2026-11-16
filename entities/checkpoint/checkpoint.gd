extends Area2D

signal activated(spawn_position: Vector2)

@onready var color_rect: ColorRect = $ColorRect
@onready var spawn_point: Marker2D = $SpawnPoint

var is_activated: bool = false

func _on_body_entered(_body: Node2D) -> void:
	if is_activated:
		return
	
	is_activated = true
	
	color_rect.color = Color(0.0, 1.0, 0.0, 1.0)
	
	activated.emit(spawn_point.global_position)
