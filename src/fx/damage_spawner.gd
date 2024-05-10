extends Marker2D

@export var fx: PackedScene


func spawn(on: Node, damage: int) -> void:
	var instance := fx.instantiate()
	instance.global_position = global_position
	
	var damage_label := instance.get_node("Label") as Label
	damage_label.set_deferred(&"text", str(-damage))
	
	on.call_deferred(&"add_child", instance)
