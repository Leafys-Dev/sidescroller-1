extends Node2D

@onready var player: CharacterBody2D = $Player

var current_spawn_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_spawn_position = player.global_position
	
	for checkpoint in get_tree().get_nodes_in_group("checkpoints"):
		checkpoint.activated.connect(_on_checkpoint_activated)
	
	for hazard in get_tree().get_nodes_in_group("hazards"):
		hazard.triggered.connect(_on_hazard_triggered)
	
func _on_checkpoint_activated(spawn_pos: Vector2) -> void:
	current_spawn_position = spawn_pos

func _on_hazard_triggered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity = Vector2.ZERO
		body.global_position = current_spawn_position
