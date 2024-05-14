extends CanvasLayer

@onready var animation_player := $AnimationPlayer


func fade_in(gold: int, waves: int, kills: int) -> void:
	%Gold.text = str(gold)
	%Waves.text = str(waves - 1)
	%Kills.text = str(kills)
	%Score.text = str((gold + kills) * waves)
	animation_player.play(&"fade_in")


func fade_out() -> void:
	animation_player.play_backwards(&"fade_in")
	await animation_player.animation_finished
	
	await get_tree().create_timer(0.01).timeout
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$TextureRect.texture = texture
	
	animation_player.play(&"transition")
	await animation_player.animation_finished
	
	get_tree().reload_current_scene()
