extends "res://src/characters/non_playable.gd"

@onready var behavior: ChaseBehavior = $ChaseBehavior


func _ready() -> void:
	set_physics_process(not Engine.is_editor_hint())
	
	var player_path := NodePath(&"%Player")
	if not behavior.target:
		if has_node(player_path):
			behavior.target = get_node(player_path)


func _physics_process(delta: float) -> void:
	if state_machine.is_movement_allowed():
		behavior.follow(speed * SPEED_MOD * delta)
		_turn_to(behavior.target.global_position)
		move_and_slide()


func clear_target() -> void:
	set_physics_process(false)
	behavior.clear_target()
