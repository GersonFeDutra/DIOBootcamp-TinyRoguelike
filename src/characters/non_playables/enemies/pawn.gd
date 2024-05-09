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


func _switch_attack_animation(to: Weapon) -> void:
	state_machine.states[behavior.ChaseStates.ATTACKING] = \
			weapon_to_state[to]
