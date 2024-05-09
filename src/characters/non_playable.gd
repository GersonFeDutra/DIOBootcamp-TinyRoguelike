extends "res://src/character.gd"

@onready var hurt_area := $HurtArea
@onready var hit_area := $HitArea
@onready var sprite := $AnimatedSprite2D
@onready var state_machine := $StateMachine


func _flip(to_left: bool) -> void:
	var scale_h: float = -1 if to_left else 1
	hurt_area.scale.x = scale_h
	hit_area.scale.x = scale_h
	sprite.scale.x = scale_h
