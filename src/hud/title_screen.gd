extends CenterContainer

@export var start: PackedScene


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(start)
	ControllsGuide.start()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	OS.shell_open("https://gersonfedutra.itch.io/tiny-roguelike")
