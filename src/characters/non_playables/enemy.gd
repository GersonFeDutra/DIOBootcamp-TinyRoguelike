extends "res://src/characters/non_playable.gd"

@onready var behavior: ChaseBehavior = $ChaseBehavior


func _ready() -> void:
	set_physics_process(not Engine.is_editor_hint())
	
	if not behavior.target:
		var playables: Array[Node] = get_tree().get_nodes_in_group("playable")
		playables.shuffle()
		
		if playables.is_empty():
			set_physics_process(false)
		else:
			behavior.target = playables[0]


func _physics_process(delta: float) -> void:
	if state_machine.is_movement_allowed():
		behavior.follow(speed * SPEED_MOD * delta)
		_turn_to(behavior.target.global_position)
		move_and_slide()


func clear_target() -> void:
	set_physics_process(false)
	behavior.clear_target()


func _die() -> void:
	$LootSpawner.spawn(get_parent(), flip_h)
	super()
