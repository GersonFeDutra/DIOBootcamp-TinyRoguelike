extends Marker2D

@export var fx: PackedScene


func spawn(on: Node, flip_h: bool) -> void:
	var instance := fx.instantiate()
	instance.global_position = global_position
	instance.set_deferred(&"flip_h", flip_h)
	on.call_deferred(&"add_child", instance)
