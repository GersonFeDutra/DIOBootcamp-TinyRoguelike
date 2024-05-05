extends Node

var ignore_damage: bool


func _ready() -> void:
	if OS.is_debug_build():
		ignore_damage = ProjectSettings.get_setting(&"application/run/ignore_damage", false)
	else:
		queue_free()
