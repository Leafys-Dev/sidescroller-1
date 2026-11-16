extends Path2D

@onready var path_follow: PathFollow2D = $PathFollow2D

@export var speed: float = 80.0
@export var ping_pong: bool = true
@export var direction: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path_follow.loop = not ping_pong

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	path_follow.progress += speed * direction * delta
	
	if ping_pong:
		if path_follow.progress_ratio >= 1.0:
			direction = -1.0
		elif path_follow.progress_ratio <= 0.0:
			direction = 1.0
