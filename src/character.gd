extends CharacterBody2D

const SPEED_MOD := 100.  ## 1mpx
@export_range(.1, 1000.) var speed: float = 100. ## [mpx/s]

var flip_h: bool:
	set(value):
		if value != flip_h:
			_flip(value)
		flip_h = value


func _flip(_to_left: bool) -> void:
	pass


func _turn_to(target_position: Vector2) -> void:
	self.flip_h = target_position.x < global_position.x


func _die() -> void:
	$FXSpawner.spawn(get_parent(), flip_h)
	queue_free()


# TODO -> Transfer this to a connection with a BehaviorManager
# @Virtual
func _on_hurted(_damage: int) -> void:
	pass
