## Base class for IA behavior.
class_name Behavior
extends Node

var none_call = func(_arg: int) -> void:
	pass
enum BaseStates {
	IDLE = 0,
}
var state: int = BaseStates.IDLE:
	set(value):
		process_transition.call(value)
		state = value
var transitions := {}
var process_transition: Callable = _process_transition

var puppet: CharacterBody2D
@export var state_machine: StateMachine


func _ready() -> void:
	_add_transition(BaseStates.IDLE)
	
	# TODO -> sanity checks
	puppet = get_parent()
	
	set_transition_process(not (
			Engine.is_editor_hint() or
			puppet.process_mode == Node.PROCESS_MODE_DISABLED) )
	
	await get_tree().process_frame
	next_state()


func _add_transition(to: int, delay: float = 0., inbetween = null) -> void:
	transitions[to] = BehaviorTransition.new(to, delay, inbetween)


func set_transition_process(enable: bool) -> void:
	if enable:
		process_transition = _process_transition
	else:
		process_transition = none_call


func _process_transition(to: int) -> void:
	var behavior := transitions[to] as BehaviorTransition
	assert(behavior != null, "Transition[%s] is not a behavior transition" % to)
	behavior.transition(self)


func next_state() -> void:
	self.state = BaseStates.IDLE
