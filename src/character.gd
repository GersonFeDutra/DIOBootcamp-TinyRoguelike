extends CharacterBody2D

const SPEED_MOD := 100.  ## 1mpx
@export_range(.1, 1000.) var speed: float = 100. ## [mpx/s]
@onready var damage_fx_spawner := $DamageFxSpawner
@onready var heal_fx_spawner := $HealFxSpawner
@onready var hurt_area: Area2D = $HurtArea

var flip_h: bool:
	set(value):
		if value != flip_h:
			_flip(value)
		flip_h = value


func _flip(_to_left: bool) -> void:
	pass


func _turn_to(target_position: Vector2) -> void:
	self.flip_h = target_position.x < global_position.x


func _die() -> void:
	$DeathFxSpawner.spawn(get_parent(), flip_h)
	queue_free()


# TODO -> Transfer this to a connection with a BehaviorManager
func _on_hurted(damage: int) -> void:
	damage_fx_spawner.spawn(get_parent(), damage)


func _on_healed(amount: int) -> void:
	heal_fx_spawner.spawn(get_parent(), amount)
