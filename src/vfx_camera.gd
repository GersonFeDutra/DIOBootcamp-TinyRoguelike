extends Camera2D

@export var strength: float = 30.
@export var fade: float = 5.
@export var zoom_force: float = 1.1

var rng := RandomNumberGenerator.new()
var shake_force: float


func shake(force: float = strength) -> void:
	shake_force = force
	zoom = Vector2.ONE * zoom_force


func _process(delta: float) -> void:
	if shake_force > 0:
		_apply_shake_force(delta)
		_apply_zoom(delta)


func _apply_shake_force(delta: float) -> void:
	shake_force = lerpf(shake_force, 0, fade * delta)
	offset = random_offset()


func _apply_zoom(delta: float) -> void:
	var zoom_out: float = lerpf(zoom.x, 1., fade * delta)
	zoom.x = zoom_out
	zoom.y = zoom_out


func random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_force, shake_force),
		rng.randf_range(-shake_force, shake_force)
	)
