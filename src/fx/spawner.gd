extends Marker2D

@export var fx: PackedScene
@export var cry: AudioStream
@export var cry_pitch_min: float = 1.
@export var cry_pitch_max: float = 1.5
@export var disable_cry: bool = false


func spawn(on: Node, flip_h: bool) -> void:
	_spawn_fx(on, flip_h)


func _spawn_fx(on: Node, flip_h: bool) -> void:
	var instance := fx.instantiate()
	instance.global_position = global_position
	
	if instance.has_node(^"CrySFX"):
		var mixer = instance.get_node(^"CrySFX")
		
		if disable_cry:
			mixer.queue_free()
		elif cry:
			mixer.stream = cry
			mixer.min_pitch = cry_pitch_min
			mixer.max_pitch = cry_pitch_max
	
	_add_instance(instance, on, flip_h)


func _add_instance(instance: Node, to: Node, flip_h: bool) -> void:
	instance.set_deferred(&"flip_h", flip_h)
	to.call_deferred(&"add_child", instance)
