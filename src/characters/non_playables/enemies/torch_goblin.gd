extends "res://src/characters/non_playables/enemy.gd"


func _play_attack() -> void:
	animation_player.play(&"torch_goblin/atk")

