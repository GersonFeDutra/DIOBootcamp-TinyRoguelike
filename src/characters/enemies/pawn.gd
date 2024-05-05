extends "res://src/characters/enemy.gd"

const Playable := preload("res://src/characters/playable.gd")
@export var target: Playable
@onready var sprite := $AnimatedSprite2D
@onready var animation_player := $AnimationPlayer


func _ready() -> void:
	var player_path := NodePath(&"%Player")
	
	if not target and has_node(player_path):
		target = get_node(player_path)
	
	set_physics_process(target != null)
	
	if target:
		sprite.play("run")


func _physics_process(delta: float) -> void:
	velocity = _follow(target.global_position, delta)
	
	_turn_to(target.global_position)
	
	move_and_slide()


func _flip(to_left: bool) -> void:
	sprite.flip_h = to_left


func _jutsu(target_position: Vector2, delta: float) -> Vector2:
	var desired_velocity: Vector2 = \
			(target_position - global_position)\
			* speed * delta
	return desired_velocity - velocity


# TODO -> steering
func _follow(target_position: Vector2, delta: float) -> Vector2:
	var desired_velocity: Vector2 = \
			global_position.direction_to(target_position) \
			* speed * SPEED_MOD * delta
	return desired_velocity


func _on_hurted(_damage: int) -> void:
	animation_player.play("hurt")
