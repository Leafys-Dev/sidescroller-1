class_name StateMachine

extends Node

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	await owner.ready
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.entity = get_parent()
			child.state_machine = self
	
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		var next_state := current_state.update(delta)
		
		if next_state != "":
			change_state(next_state)

func _physics_process(delta: float) -> void:
	if current_state:
		var next_state := current_state.physics_update(delta)
		
		if next_state != "":
			change_state(next_state)

func change_state(next_state_name: String) -> void:
	var new_state: State = states.get(next_state_name.to_lower())
	if not new_state or new_state == current_state:
		return
	else: 
		current_state.exit()
		current_state = new_state
		current_state.enter()
