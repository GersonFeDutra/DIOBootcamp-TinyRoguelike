extends "res://src/fx/spawn/resource.gd"


func _collect_to(to: Playable) -> void:
	$GoldFxSpawner.spawn(get_parent(), value)
	super(to)
