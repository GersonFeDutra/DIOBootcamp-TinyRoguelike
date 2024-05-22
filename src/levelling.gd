extends Node

const Spawner = preload("res://src/lib/spawner.gd")

## Ratio of mobs increased each wave [x mobs/min]
@export var spawn_grow: float = 1.5
# There is a bug on Godot editor that
# don't allow to type this to Spawn
@export var spawner: Node2D
@export var amplitude: float = 4.

@onready
var base_frequency: float = spawner.frequency
@onready var wave_timer: Timer = $WaveTimer
var current_wave: int = 1
@onready var wave_progress_bar: ProgressBar = %WaveProgressBar

@export_exp_easing("attenuation")
var interpolation_easing: float = 1.0
@export var interpolation_strength: float = 5.0
var _wave_changed: bool

@export var next_wave_sfx: AudioStreamPlayer


func _ready() -> void:
	wave_progress_bar.value = wave_progress_bar.min_value


func _process(delta: float) -> void:
	spawner.frequency = _get_spawn_frequency(wave_timer)
	wave_progress_bar.value = _get_progress_update(wave_timer, delta)


## Return the frequency of spawn based on a senoidal function.
func _get_spawn_frequency(from: Timer) -> float:
	var time: float = \
			from.wait_time \
			- from.time_left
	var total_time := time * current_wave
	var growth_ratio := base_frequency \
			+ spawn_grow * total_time / from.wait_time
	var wave_frequency: float = amplitude * sin(
		TAU * total_time / from.wait_time
	)
	
	return max(wave_frequency + growth_ratio, base_frequency)


func _get_progress_update(from: Timer, delta: float) -> float:
	var time: float = from.wait_time - from.time_left
	var progress: float = remap(time, 0, from.wait_time,
			wave_progress_bar.min_value,
			wave_progress_bar.max_value)
	var target_value := .0 if _wave_changed else progress
	var strength: float = \
			ease(100 - progress / 100., interpolation_easing) \
			* interpolation_strength
	progress = lerp(
			wave_progress_bar.value,
			target_value, delta * strength)
	
	if wave_progress_bar.value <= 1.:
		_wave_changed = false
	
	return progress


func _next_wave() -> void:
	const WAVE_PITCH_STEP := .1
	const WAVE_PITCH_MAX := 3.
	current_wave += 1
	next_wave_sfx.pitch_scale = fmod(
				next_wave_sfx.pitch_scale + WAVE_PITCH_STEP,
				WAVE_PITCH_MAX)
	next_wave_sfx.play()
	_wave_changed = true
