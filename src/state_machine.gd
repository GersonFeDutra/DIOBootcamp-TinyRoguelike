@tool
@icon("res://assets/state_machine_icon.svg")
class_name StateMachine
## Generic current_state machine for 2D characters behavior.
## Using the strategy pattern: [State] as [Resource].
extends Node

@export var animation_tree: AnimationTree:
	set(value):
		animation_tree = value
		update_configuration_warnings()
		if animation_tree and not animation_tree.tree_root:
			animation_tree.tree_root = AnimationNodeStateMachine.new()

@export var states: Dictionary
@export var current_state: State:
	set(value):
		current_state = value
		update_configuration_warnings()

var _next: State
var _next_direction: Vector2
var is_animation_finished: bool


func _ready() -> void:
	auto_set_tree()
	attach_waiting_states()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_CHILD_ORDER_CHANGED:
			auto_set_tree()


func auto_set_tree() -> void:
	if animation_tree:
		return
	for child in get_children():
		if child is AnimationTree:
			self.animation_tree = child
			break


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if not animation_tree:
		warnings.append("No AnimationTree node selected.")
	if not current_state:
		warnings.append("Default current_state not set.")
	return PackedStringArray(warnings)


func attach_waiting_states() -> void:
	for state in states.values():
		if state.transition == State.TransitionMode.WAIT_FINISH:
			state.waiting_state_finished.connect(trigger_next_state)


func trigger_next_state() -> void:
	if _next:
		is_animation_finished = false
		current_state = _next
		_next.trigger(animation_tree, _next_direction)
		_next = null
	else:
		is_animation_finished = true


func change_state_from(key, direction := Vector2.ZERO) -> void:
	change_state(states[key], direction)


func change_state(to: State, direction := Vector2.ZERO) -> bool:
	if to == current_state:
		return false
	match current_state.transition:
		State.TransitionMode.IMMEDIATE:
			_set_current_state(to, direction)
			return true
		State.TransitionMode.WAIT_FINISH:
			if is_animation_finished:
				_set_current_state(to, direction)
				return true
			else:
				_next = to
				return false
	return false


func _set_current_state(to: State, direction: Vector2) -> void:
	self.current_state = to
	current_state.trigger(animation_tree, direction)


func is_movement_allowed() -> bool:
	return current_state.is_movement_allowed
