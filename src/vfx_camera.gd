extends Camera2D

@export var strength: float = 30.
@export var fade: float = 5.

var rng := RandomNumberGenerator.new()
var shake_force: float


func shake() -> void:
	shake_force = strength


func _process(delta: float) -> void:
	if shake_force > 0:
		shake_force = lerpf(shake_force, 0, shake_force * delta)
		offset = random_offset()


func random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_force, shake_force),
		rng.randf_range(-shake_force, shake_force)
	)
