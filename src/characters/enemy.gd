extends "res://src/character.gd"

const DYING_FX := preload("res://src/fx/dying.tscn")

func _die() -> void:
	var fx := DYING_FX.instantiate()
	fx.global_position = $FXSpawner.global_position
	get_parent().add_child(fx)
	queue_free()


# @Virtual
func _hurt() -> void:
	pass
