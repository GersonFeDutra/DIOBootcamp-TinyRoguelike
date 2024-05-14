extends Area2D

signal killed

const HurtArea := preload("res://src/areas/hurt.gd")
@export var damage: int = 1


func _on_area_entered(area: Area2D) -> void:
	_hit(area)
	killed.emit()


func _hit(area: HurtArea) -> void:
	assert(area != null, "area is not a HurtArea")
	area.take_damage(damage)
