extends Area2D

signal health_depleated
signal hurted(int)

@export var health_max: int = 3
var health: int = health_max:
	set(value):
		var old_health = health
		health = value
		
		if value <= 0 and old_health > 0:
			health_depleated.emit()


func take_damage(damage: int) -> void:
	self.health -= damage
	hurted.emit(damage)
