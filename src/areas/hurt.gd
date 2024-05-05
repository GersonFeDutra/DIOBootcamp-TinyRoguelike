extends Area2D

signal health_depleated

const HitArea := preload("res://src/areas/hit.gd")
@export var health_max: int = 3
var health: int = health_max:
	set(value):
		var old_health = health
		health = value
		
		if value <= 0 and old_health > 0:
			health_depleated.emit()


func _on_hit(area: Area2D) -> void:
	var hit_box := area as HitArea
	assert(hit_box != null, "collided area is not a hit area")
	
	self.health -= area.damage
