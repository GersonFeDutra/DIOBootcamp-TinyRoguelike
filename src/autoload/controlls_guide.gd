extends Node2D

const ResourceSpawn = preload("res://src/fx/spawn/resource.gd")
var target_spawn: ResourceSpawn
var intact_remote: RemoteTransform2D

@export var fade_threshhold: float = .1
@export var fade_intensity: float = 0.01

@onready var arrow_keys: Node2D = %ArrowKeys
@export var anchor_distance: float = -128.

var _was_interact_guide_spawned: bool = false
@onready var interact_keys: Node2D = %InteractKeys

var faded_keys: int
var is_finished: bool


func start() -> void:
	await get_tree().process_frame
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
			%XboxSeriesXY.visible = value
		DeviceDetector.JoypadType.SONY:
			%Ps4Circle.visible = value
			%Ps4Triangle.visible = value
		DeviceDetector.JoypadType.NINTENDO:
			%SwitchA.visible = value
			%SwitchX.visible = value
		DeviceDetector.JoypadType.GENERIC:
			for child in %Console.get_children():
				child.visible = value


func setup() -> void:
	if is_finished:
		return
	await get_tree().process_frame
	set_process_input(true)
	follow_playable()
	set_playable_can_attack(false)
	_guide_fade_in(%ArrowKeys)


func skip() -> void:
	if is_finished:
		return
	set_playable_can_attack(true)
	_finish()


func _finish() -> void:
	unfollow_playable()
	is_finished = true
	set_process_input(false)


func finish() -> void:
	_finish()
	for child in get_children(true):
		child.queue_free()


func follow_playable() -> void:
	for playable in get_tree().get_nodes_in_group(&"playable"):
		_attach_new_remote(playable, $PlayerAnchor)
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
		faded_keys += 1
		await _guide_fade_out(%AttackKeys)
		_finish()


func action_fade_key(
		event: InputEvent, action: StringName, key: Node2D) -> void:
	if event.is_action(action):
		key.modulate.a = \
				lerpf(key.modulate.a, 0.0, fade_intensity)
		
		if key.modulate.a <= fade_threshhold:
			update_key_visibility(key)


func _guide_fade_in(guide: Node2D) -> void:
	print(guide.name)
	guide.get_node(^"AnimationPlayer").play(&"fade_in")


func _guide_fade_out(guide: Node2D) -> void:
	var player: AnimationPlayer = guide.get_node(^"AnimationPlayer")
	player.play_backwards(&"fade_in")
	
	await player.animation_finished
	guide.queue_free()


func update_key_visibility(key: Node2D) -> void:
	if key.visible:
		faded_keys += 1
		if faded_keys == 4:
			set_playable_can_attack(true)
			%AttackKeys.get_node("AnimationPlayer").play(&"fade_in")
	key.visible = false


func attach_interact_guide(node: ResourceSpawn) -> void:
	if _was_interact_guide_spawned:
		return
	_was_interact_guide_spawned = true
	
	await get_tree().process_frame
	target_spawn = node
	intact_remote = _attach_new_remote(node, interact_keys)
	interact_keys.visible = true
	_guide_fade_in(%InteractKeys)


func _attach_new_remote(to: Node2D, target: Node2D) -> RemoteTransform2D:
	var remote := RemoteTransform2D.new()
	remote.name = &"ControllsGuideRemoteTransform"
	remote.position.y += anchor_distance
	remote.update_rotation = false
	remote.update_scale = false
	to.add_child(remote, false)
	remote.remote_path = remote.get_path_to(target)
	return remote


func on_resource_collected(spawn: ResourceSpawn) -> void:
	if spawn == target_spawn:
		await _guide_fade_out(%InteractKeys)
		#intact_remote.queue_free() # Already freed by owner
