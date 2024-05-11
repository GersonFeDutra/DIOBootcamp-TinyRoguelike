extends Marker2D

@export var fx: PackedScene
@export var prefix: String


func spawn(on: Node, value: int) -> void:
	var instance := fx.instantiate()
	instance.global_position = global_position
	
	var damage_label := instance.get_node("Label") as Label
	damage_label.set_deferred(&"text", prefix + str(value))
	
	on.call_deferred(&"add_child", instance)
