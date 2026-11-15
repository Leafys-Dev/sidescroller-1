class_name State

extends Node

var entity: CharacterBody2D
var state_machine: StateMachine

func enter() -> void: 
	pass

func exit() -> void:
	pass

func update(_delta: float) -> String: return ""

func physics_update(_delta: float) -> String: return ""
