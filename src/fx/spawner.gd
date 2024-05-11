extends Marker2D

@export var fx: PackedScene


func spawn(on: Node, flip_h: bool) -> void:
	var instance := fx.instantiate()
	instance.global_position = global_position
	_add_instance(instance, on, flip_h)


func _add_instance(instance: Node, to: Node, flip_h: bool) -> void:
	instance.set_deferred(&"flip_h", flip_h)
	to.call_deferred(&"add_child", instance)
