extends "res://src/character.gd"


func _die() -> void:
	$FXSpawner.spawn(get_parent(), flip_h)
	queue_free()


# @Virtual
func _on_hurted(_damage: int) -> void:
	pass
