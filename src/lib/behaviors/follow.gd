class_name FollowBehavior
extends Behavior

enum FollowStates {
	IDLE = 0, FOLLOWING = 1,
}

@export_range(0., 10.) var delay: float = .5
@export var target: Node2D


func _ready() -> void:
	super()
	_add_transition(
			FollowStates.FOLLOWING, delay,
			FollowStates.IDLE)


func next_state() -> void:
	if _has_target():
		self.state = FollowStates.FOLLOWING
	else:
		super()


# TODO -> rename/turn public
func _has_target() -> bool:
	return target != null


func clear_target() -> void:
	self.state = BaseStates.IDLE
	target = null
	set_transition_process(false)


func follow(speed: float) -> void:
	puppet.velocity = _get_following_velocity(
			puppet.global_position,
			target.global_position,
			speed)


# TODO -> steering
func _get_following_velocity(
		from: Vector2, to: Vector2,
		speed: float ) -> Vector2:
	var desired_velocity: Vector2 = \
			from.direction_to(to) * speed
	return desired_velocity
