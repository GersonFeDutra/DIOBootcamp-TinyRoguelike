extends Marker2D

const MIN_PITCH: float = .5
const MAX_PITCH: float = 1.5

@export var fx: PackedScene
@export var prefix: String


func spawn(on: Node, value: int) -> void:
	var instance := fx.instantiate()
	instance.global_position = global_position
	
	if instance.has_node(^"Label"):
		_set_label_text(instance.get_node(^"Label"), value)
	elif instance.has_node(^"RichTextLabel"):
		_set_rich_text_label_text(instance.get_node(^"RichTextLabel"), value)
	
	if instance.has_node(^"AudioStreamPlayer2D"):
		_set_audio_stream_player_pitch(
				instance.get_node(^"AudioStreamPlayer2D"), value)
	
	on.call_deferred(&"add_child", instance)


func _set_label_text(label: Label, value: int) -> void:
	assert(label != null, "No label found.")
	label.set_deferred(&"text", prefix + str(value))


func _set_rich_text_label_text(label: RichTextLabel, value: int) -> void:
	assert(label != null, "No rich text label found.")
	label.set_deferred(&"text",
			"[center][wave amp=50. freq=%s]%s[/wave][/center]" % [
				str(clamp(5 + value, 5, 20)),
				(prefix + str(value)),
			] )


func _set_audio_stream_player_pitch(player: AudioStreamPlayer2D, value: float) -> void:
	player.pitch_scale = randf_range(MIN_PITCH, MAX_PITCH) + 0.1 * value
