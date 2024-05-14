extends "res://src/character.gd"

const Enemy := preload("res://src/characters/non_playables/enemy.gd")

signal gold_changed(to: int)

enum ResourceTypes {
	MEAT, GOLD
}
@export var gold: int:
	set(value):
		var old_value := gold
		gold = value
		
		if gold != old_value:
			gold_changed.emit(value)

var kills: int


# TODO -> implement resource mechanic
func add_resource(type: ResourceTypes, value: int = 1) -> void:
	match type:
		ResourceTypes.MEAT:
			hurt_area.heal(value)
		ResourceTypes.GOLD:
			self.gold += value


func _die() -> void:
	for node in get_tree().get_nodes_in_group(&"enemies"):
		var enemy := node as Enemy
		assert(enemy != null, "node is not an enemy")
		enemy.clear_target()
	super()


func _on_killed() -> void:
	kills += 1
