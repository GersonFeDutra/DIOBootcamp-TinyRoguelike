# TODO -> use state machine on all characters
extends Node

enum States { IDLE = 0, RUNNING = 1, ATTACKING = 2 }
var _state = States.IDLE
var _target_state: States

const STATE_TO_ANIM = {
	States.IDLE: &"RESET",
	States.RUNNING: &"run",
}

var _is_sword_right: bool
@export var animation_player: AnimationPlayer


func change_state(to: States, direction := Vector2.ZERO) -> void:
	if to == _state:
		return
	
	match to:
		States.IDLE, States.RUNNING:
			var target_anim: StringName = STATE_TO_ANIM[to]
			if _state == States.ATTACKING:
				_target_state = to
			else:
				animation_player.play(target_anim)
				_state = to
		States.ATTACKING:
			_sword_attack(direction)
			_state = to
			_target_state = _state


func _sword_attack(direction: Vector2) -> void:
	var animation: StringName
	if direction.y < 0.:
		animation = &"atk_up_a"
	elif direction.y > 0.:
		animation = &"atk_down_a"
	else:
		animation = &"atk_h_a" if _is_sword_right else &"atk_h_b"
	animation_player.play(animation)
	
	await animation_player.animation_finished
	_state_to_target()


func _state_to_target() -> void:
	var target_anim: StringName = STATE_TO_ANIM[_target_state]
	animation_player.play(target_anim)
	_is_sword_right = not _is_sword_right
	_state = _target_state


func is_movement_allowed() -> bool:
	return _state != States.ATTACKING
