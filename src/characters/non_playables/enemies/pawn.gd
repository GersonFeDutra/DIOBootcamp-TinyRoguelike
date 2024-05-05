extends "res://src/characters/non_playables/enemy.gd"

enum Weapon { HAMMER, AXE }
@export var weapon: Weapon


func _play_attack() -> void:
	const WEAPON_TO_ANIM := {
		Weapon.HAMMER: &"pawn/atk_hammer",
		Weapon.AXE: &"pawn/atk_axe",
	}
	animation_player.play(WEAPON_TO_ANIM[weapon])
