extends "res://src/character.gd"

const Enemy := preload("res://src/characters/non_playables/enemy.gd")
#var resources: int


# TODO -> implement resource mechanic
func add_resource(value: int = 1) -> void:
	hurt_area.heal(value)


func _die() -> void:
	for node in get_tree().get_nodes_in_group(&"enemies"):
		var enemy := node as Enemy
		assert(enemy != null, "node is not an enemy")
		enemy.clear_target()
	super()
