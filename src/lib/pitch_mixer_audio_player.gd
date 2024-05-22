class_name PitchMixerAudioPlayer
extends AudioStreamPlayer2D

@export var min_pitch: float = .5
@export var max_pitch: float = 1.5
@export var auto_play_mixed: bool
var rng := RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	if auto_play_mixed:
		pitch_play()


func pitch_play(from_position: float = 0.0) -> void:
	pitch_scale = rng.randf_range(min_pitch, max_pitch)
	play(from_position)
