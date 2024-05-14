extends Node2D

@export var fade_threshhold: float = .1
@export var fade_intensity: float = 0.01
@onready var arrow_keys: Node2D = $ArrowKeys
@export var anchor_distance: float = -128.

var faded_keys: int
var is_finished: bool


func _ready() -> void:
	setup()
	Input.joy_connection_changed.connect(update_joypad_display)
	update_connected_joypads_display()


func update_connected_joypads_display() -> void:
	var joypads := update_any_joypad_connect_display()
	
	for joy in joypads:
		_set_display_visibility(joy, true)


func update_joypad_display(device: int, connected: bool) -> void:
	_set_display_visibility(device, connected)
	update_any_joypad_connect_display()


func update_any_joypad_connect_display() -> Array[DeviceDetector.JoypadType]:
	var joypads := DeviceDetector.get_detected_joypads()
	var has_joypads := not joypads.is_empty()
	
	%SwitchDpadLeft.visible = has_joypads
	%SwitchDpadDown.visible = has_joypads
	%SwitchDpadRight.visible = has_joypads
	%SwitchDpadUp.visible = has_joypads
	
	return joypads


func _set_display_visibility(from_device: int, value: bool) -> void:
	match from_device:
		DeviceDetector.JoypadType.XBOX:
			%XboxSeriesXB.visible = value
		DeviceDetector.JoypadType.SONY:
			%Ps4Circle.visible = value
		DeviceDetector.JoypadType.NINTENDO:
			%SwitchA.visible = value
		DeviceDetector.JoypadType.GENERIC:
			for child in %Console.get_children():
				child.visible = value


func setup() -> void:
	if is_finished:
		return
	await get_tree().process_frame
	follow_playable()
	set_playable_can_attack(false)
	%ArrowKeys.get_node("AnimationPlayer").play(&"fade_in")


func skip() -> void:
	if is_finished:
		return
	set_playable_can_attack(true)
	finish()


func finish() -> void:
	unfollow_playable()
	is_finished = true
	set_process_input(false)
	for child in get_children(true):
		child.queue_free()


func follow_playable() -> void:
	for playable in get_tree().get_nodes_in_group(&"playable"):
		var remote := RemoteTransform2D.new()
		remote.name = "ControllsGuideRemoteTransform"
		remote.position.y += anchor_distance
		remote.update_rotation = false
		remote.update_scale = false
		playable.add_child(remote)
		remote.remote_path = remote.get_path_to(self)
		break


func unfollow_playable() -> void:
	for playable in get_tree().get_nodes_in_group(&"playable"):
		if playable.has_node(^"ControllsGuideRemoteTransform"):
			playable.get_node(^"ControllsGuideRemoteTransform").queue_free()
		break


func set_playable_can_attack(to: bool) -> void:
	for playable in get_tree().get_nodes_in_group(&"playable"):
		playable.can_attack = to


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	
	action_fade_key(event, &"move_right", %ArrowRightKey)
	action_fade_key(event, &"move_left", %ArrowLeftKey)
	action_fade_key(event, &"move_up", %ArrowUpKey)
	action_fade_key(event, &"move_down", %ArrowDownKey)
	
	if faded_keys == 4 and event.is_action(&"attack"):
		var player: AnimationPlayer = %AttackKeys.get_node("AnimationPlayer")
		player.play_backwards(&"fade_in")
		faded_keys += 1
		
		await player.animation_finished
		finish()


func action_fade_key(
		event: InputEvent, action: StringName, key: Node2D) -> void:
	if event.is_action(action):
		key.modulate.a = \
				lerpf(key.modulate.a, 0.0, fade_intensity)
		
		if key.modulate.a <= fade_threshhold:
			update_key_visibility(key)


func update_key_visibility(key: Node2D) -> void:
	if key.visible:
		faded_keys += 1
		if faded_keys == 4:
			set_playable_can_attack(true)
			%AttackKeys.get_node("AnimationPlayer").play(&"fade_in")
			fade_intensity *= 10.
	key.visible = false
