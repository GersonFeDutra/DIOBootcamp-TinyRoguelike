extends "res://src/characters/non_playables/enemy.gd"


func _die() -> void:
	$ExtraLootSpawner.spawn(get_parent(), flip_h)
	super()
