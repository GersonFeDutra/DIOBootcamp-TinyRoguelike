@tool
extends "res://src/characters/non_playables/enemy.gd"

enum Weapon { HAMMER, AXE }
var weapon_to_state := {
	Weapon.HAMMER: preload("res://assets/states/atk_hammer.tres"),
	Weapon.AXE: preload("res://assets/states/atk_axe.tres"),
}
@export var weapon: Weapon:
	set(value):
		weapon = value
		
		if Engine.is_editor_hint():
			_switch_attack_animation(value)

var rng := RandomNumberGenerator.new()
@export var attack_pitch_min: float = 1.0
@export var attack_pitch_max: float = 2.0
@onready var attack_sfx: AudioStreamPlayer2D = $AttackSfx


func _ready() -> void:
	rng.randomize()
	super()


func _switch_attack_animation(to: Weapon) -> void:
	state_machine.states[behavior.ChaseStates.ATTACKING] = \
			weapon_to_state[to]


func play_attack_sfx() -> void:
	attack_sfx.pitch_scale = rng.randf_range(
			attack_pitch_min, attack_pitch_max)
	attack_sfx.play()
