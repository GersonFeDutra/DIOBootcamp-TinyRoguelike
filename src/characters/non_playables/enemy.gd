extends "res://src/characters/non_playable.gd"

const Playable := preload("res://src/characters/playable.gd")
@export var target: Playable

enum EnemyStates { ATTACKING = 2, HURTING = 3, }

@onready var target_area: Area2D = $TargetArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_actions = {
		NpcStates.IDLE: _play_idle,
		NpcStates.FOLLOWING: _play_run,
		EnemyStates.ATTACKING: _play_attack,
		EnemyStates.HURTING: _play_hurt,
	}
	
	var player_path := NodePath(&"%Player")
	if not target and has_node(player_path):
		target = get_node(player_path)
	
	_play_idle()
	set_physics_process(false)
	
	await get_tree().process_frame
	next_state()


func next_state() -> void:
	if target_area.has_overlapping_bodies():
		self.state = EnemyStates.ATTACKING
		set_physics_process(false)
	else:
		super()


func _has_target() -> bool:
	return target != null


func _physics_process(delta: float) -> void:
	velocity = _follow(target.global_position, delta)
	
	_turn_to(target.global_position)
	
	move_and_slide()


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
	set_physics_process(false)
	self.state = EnemyStates.HURTING


func _play_hurt() -> void:
	animation_player.play(&"hurt")
	
	await animation_player.animation_finished
	next_state()


func _play_idle() -> void:
	animation_player.play(&"idle")


func _play_run() -> void:
	animation_player.play(&"run")


# @Virtual
func _play_attack() -> void:
	pass
