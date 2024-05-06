class_name State
extends Resource

signal waiting_state_finished

enum TransitionMode {
	IMMEDIATE, WAIT_FINISH,
}
@export var transition: TransitionMode 

@export var animation: StringName
@export var is_movement_allowed := true
@export var use_blend_space: bool


## Setup the state and play animation from tree.
func trigger(player: AnimationTree, direction: Vector2) -> void:
	var playback: AnimationNodeStateMachinePlayback = \
			player["parameters/playback"]
	
	if use_blend_space:
		var y_inverted_direction := Vector2(direction.x, -direction.y)
		player["parameters/%s/blend_position" % animation] = \
				y_inverted_direction
	
	playback.travel(animation)
	
	if transition == TransitionMode.WAIT_FINISH:
		await player.animation_finished
		waiting_state_finished.emit()
