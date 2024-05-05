extends "res://src/characters/non_playables/enemy.gd"


func _play_attack() -> void:
	animation_player.play(&"torch_goblin/atk")


func _change_state(from: int, to: int) -> void:
	if from == EnemyStates.ATTACKING:
		self.animation_player.play(&"RESET")
	
	await get_tree().physics_frame
	super(from, to)
