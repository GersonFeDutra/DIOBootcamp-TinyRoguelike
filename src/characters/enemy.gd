extends "res://src/character.gd"

const DyingFx := preload("res://src/fx/dying.gd")
const DyingFxScn := preload("res://src/fx/dying.tscn")


func _die() -> void:
	get_parent().add_child(_create_dying_fx())
	queue_free()


func _create_dying_fx() -> DyingFx:
	var fx := DyingFxScn.instantiate()
	fx.global_position = $FXSpawner.global_position
	fx.flip_h = flip_h
	return fx


# @Virtual
func _on_hurted(_damage: int) -> void:
	pass
