extends "res://src/character.gd"

var resources: int


# TODO -> implement resource mechanic
func add_resource(value: int = 1) -> void:
	resources += value
