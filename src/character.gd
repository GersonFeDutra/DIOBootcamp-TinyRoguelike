extends CharacterBody2D

const SPEED_MOD := 100.  ## 1mpx
@export_range(.1, 1000.) var speed: float = 100. ## [mpx/s]

var flip_h: bool:
	set(value):
		if value != flip_h:
			_flip(value)
		flip_h = value


func _turn_to(target_position: Vector2) -> void:
	self.flip_h = target_position.x < global_position.x


# @Virtual
func _flip(to_left: bool) -> void:
	pass
