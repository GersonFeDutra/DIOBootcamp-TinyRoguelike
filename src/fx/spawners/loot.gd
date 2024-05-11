extends "res://src/fx/spawner.gd"

## Probability[%] of spawn. If value is greater then 1,
## there is a of spawning more loot were each has a
## probability of the remaing value to spawn.
@export_range(0.0, 1.0, 0.001, "or_greater")
var chance: float = .5
@export var padding: float

var rng := RandomNumberGenerator.new()


func spawn(on: Node, flip_h: bool) -> void:
	for i in ceili(chance):
		if rng.randf() > chance:
			continue
		var instance := fx.instantiate()
		
		# TODO -> Make it account for previous spawns positions
		instance.global_position = \
				global_position + \
				(Vector2.ONE * padding).rotated(rng.randf() * TAU)
		
		_add_instance(instance, on, flip_h)
