extends "res://src/character.gd"

@onready var hurt_area := $HurtArea
@onready var hit_area := $HitArea
@onready var sprite := $AnimatedSprite2D

@export_range(0., 10.) var state_change_delay: float = .2


func NONE_CALL() -> void:
	pass

enum NpcStates {
	IDLE = 0, FOLLOWING = 1,
}
var state: int = NpcStates.IDLE:
	set(value):
		if value != state:
			_change_state(state, value)
		state = value
var _actions := {
	# Override on subclass
	NpcStates.FOLLOWING: NONE_CALL,
	NpcStates.IDLE: NONE_CALL,
}
var _current_action: Callable


func _change_state(_from: int, to: int) -> void:
	_current_action = _actions[to]
	_current_action.call()


func next_state() -> void:
	if _has_target():
		var timer := get_tree().create_timer(state_change_delay)
		
		await timer.timeout
		self.state = NpcStates.FOLLOWING
		set_physics_process(true)
	else:
		self.state = NpcStates.IDLE
		set_physics_process(false)


func _flip(to_left: bool) -> void:
	var scale_h: float = -1 if to_left else 1
	hurt_area.scale.x = scale_h
	hit_area.scale.x = scale_h
	sprite.scale.x = scale_h


# @Virtual
func _has_target() -> bool:
	return false
