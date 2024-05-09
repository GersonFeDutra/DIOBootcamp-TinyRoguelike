class_name BehaviorTransition
extends Resource

@export var next: int
@export var inbetween: int
@export var delay: float


@warning_ignore("shadowed_variable")
func _init(next: int, delay: float = 0.0, inbetween = null) -> void:
	self.next = next
	
	self.delay = delay
	if delay and inbetween == null:
		self.inbetween = next


func transition(behavior: Behavior) -> void:
	if delay:
		behavior.state_machine.change_state_from(inbetween)
		var timer := behavior.get_tree().create_timer(delay)
		await timer.timeout
	behavior.state_machine.change_state_from(next)
