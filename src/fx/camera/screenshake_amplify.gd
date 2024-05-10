extends "res://src/vfx_camera.gd"

@export_subgroup("Strength amplifier", "strength_")
@export var strength_min: float = strength
@export var strength_max: float = strength
@export var strength_base: float = strength / 10

@export_subgroup("Breath", "breath_")
@export var breath_zoom_out: float = 1.5
@export_exp_easing("inout")
var breath_ease: float = 2.
var breath_zoom: float = 1.
var is_breathing: bool


func shake_amplify(amount: float) -> void:
	shake(strength * amount)


func shake_amplify_to(amount: int) -> void:
	shake(min(strength_base * amount, strength_max))


var zoom_out_interp: float
# TODO -> Separate effects as resources from the camera
func breath() -> void:
	zoom_out_interp = 0.0
	is_breathing = true


func _process(delta: float) -> void:
	super(delta)
	
	if is_breathing:
		_breath_out(delta)


func _breath_out(delta: float) -> void:
	zoom_out_interp = lerpf(zoom_out_interp, 1.0, fade * delta)
	var zoom_out: float = 1.0 + (
			(breath_zoom_out - 1.0) *
			ease(zoom_out_interp, breath_ease))
	
	zoom.x = zoom_out
	zoom.y = zoom_out
	
	if zoom_out_interp >= 0.99:
		is_breathing = false
