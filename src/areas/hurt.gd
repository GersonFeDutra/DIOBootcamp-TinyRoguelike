extends Area2D

signal health_depleated
signal health_changed(to: int)
signal hurted(damage: int)
signal healed(amount: int)

@export var health_max: int = 3
@onready var health: int = health_max:
	set(value):
		var old_health = health
		health = value
		
		if value <= 0 and old_health > 0:
			health_depleated.emit()
		
		if old_health != health:
			health_changed.emit(health)


func take_damage(damage: int) -> void:
	self.health -= damage
	hurted.emit(damage)


func heal(amount: int) -> void:
	var new_health: int = min(health + amount, health_max)
	self.health = new_health
	
	healed.emit(new_health - health)


func is_health_depleated() -> bool:
	return health <= 0
