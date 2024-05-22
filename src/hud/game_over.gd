extends CanvasLayer

@export var music_player: AudioStreamPlayer
@onready var animation_player := $AnimationPlayer


func _ready() -> void:
	Input.joy_connection_changed.connect(update_joypad_display)
	update_connected_joypads_display()


func update_connected_joypads_display() -> void:
	for joy in DeviceDetector.get_detected_joypads():
		_set_display_visibility(joy, true)


func update_joypad_display(device: int, connected: bool) -> void:
	_set_display_visibility(device, connected)


func _set_display_visibility(from_device: int, value: bool) -> void:
	match from_device:
		DeviceDetector.JoypadType.XBOX:
			%XboxSeriesXY.visible = value
		DeviceDetector.JoypadType.SONY:
			%Ps4Triangle.visible = value
		DeviceDetector.JoypadType.NINTENDO:
			%SwitchX.visible = value
		DeviceDetector.JoypadType.GENERIC:
			for child in %Console.get_children():
				child.visible = value


func fade_in(gold: int, waves: int, kills: int) -> void:
	# TODO -> Make signal to it
	music_player.stream = preload("res://addons/FreeSFX/GameSFX/Music/Negative/Retro Negative Melody 02 - space voice pad.wav")
	music_player.play()
	
	%Gold.text = str(gold)
	%Waves.text = str(waves - 1)
	%Kills.text = str(kills)
	%Score.text = str((gold + kills) * waves)
	animation_player.play(&"fade_in")


func fade_out() -> void:
	# TODO -> Make signal to it
	music_player.stream = preload("res://addons/FreeSFX/GameSFX/Music/Negative/Retro Negative Melody 02 - space voice pad - reverse.wav")
	music_player.play()
	
	animation_player.play_backwards(&"fade_in")
	await animation_player.animation_finished
	
	await get_tree().create_timer(0.01).timeout
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$Overlay.texture = texture
	
	animation_player.play(&"transition")
	await animation_player.animation_finished
	
	if get_tree().reload_current_scene() == OK:
		ControllsGuide.setup()
