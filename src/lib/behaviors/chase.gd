@tool
# TODO -> Make a behavior controller "tree"
class_name ChaseBehavior
extends FollowBehavior

enum ChaseStates {
	IDLE = 0, CHASING = 1,
	ATTACKING = 2, HURTING = 3,
}

@export
var target_area: Area2D:
	set(value):
		target_area = value
		update_configuration_warnings()


func _ready() -> void:
	super()
	_add_transition(ChaseStates.ATTACKING)
	_add_transition(ChaseStates.HURTING)
	
	var hurt_state: State = \
			state_machine.states[ChaseStates.HURTING]
	_attach_state_to_next(hurt_state)


@warning_ignore("shadowed_variable")
func _attach_state_to_next(state: State) -> void:
	state.waiting_state_finished.connect(next_state)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := []
	if not target_area:
		warnings.append("No target area attached. Please add an [Area2D] node.")
	return PackedStringArray(warnings)


func next_state() -> void:
	if target_area.has_overlapping_bodies():
		self.state = ChaseStates.ATTACKING
	else:
		super()


# TODO -> Make a new behavior "hurt"
func _on_hurted(_damage: int) -> void:
	self.state = ChaseStates.HURTING


# TODO -> Make a new behavior "attack"
func attack() -> void:
	self.state = ChaseStates.ATTACKING
