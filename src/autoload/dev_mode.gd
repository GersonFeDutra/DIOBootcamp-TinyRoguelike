extends Node

var ignore_damage: bool
var time_scale: float:
	set(value):
		Engine.time_scale = value
		time_scale = value


func _ready() -> void:
	if OS.is_debug_build():
		ignore_damage = ProjectSettings.get_setting(&"application/run/ignore_damage", false)
		self.time_scale = ProjectSettings.get_setting(&"application/run/time_scale", 1.0)
	else:
		queue_free()
