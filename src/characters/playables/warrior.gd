extends "res://src/characters/playable.gd"

## How many frames are expected in a physics_process.
## Mostly used for delta calculations with lerp.
const IDEAL_FPS = 60
const DEAD_ZONE := .15

enum States { IDLE = 0, RUNNING = 1, ATTACKING = 2 }

@export_range(.001, 1.) var weight := .05  ## [fixed frames%]
@export var can_attack: bool = true

var _direction := Vector2.ZERO
var _is_sword_left: bool

@onready var sprite := $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fx: AnimationPlayer = $FxAnimationPlayer
@onready var state_machine := $StateMachine
@onready var hit_area := $HitArea

# TODO -> Create audio stream player subclass pitch variant
var rng := RandomNumberGenerator.new()
@export_group("Footstep", "footstep_")
@onready var footstep_sfx: AudioStreamPlayer2D = $FootstepSFX
@export_subgroup("Pitch", "footstep_sfx_self_pitch")
@export var footstep_sfx_pitch_min: float = 0.5
@export var footstep_sfx_pitch_max: float = 1.5
@onready var footstep_interval := %FootstepInterval

@export_group("Slash", "slash_")
@onready var slash_sfx: AudioStreamPlayer2D = $SlashSFX
@export_subgroup("Pitch", "footstep_sfx_self_pitch")
@export var slash_sfx_pitch_min: float = 1.5
@export var slash_sfx_pitch_max: float = 2.5


func _ready() -> void:
	rng.randomize()
	if DevMode.ignore_damage:
		$HurtArea.process_mode = Node.PROCESS_MODE_DISABLED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_left"):
		self.flip_h = true
	
	if event.is_action_pressed(&"move_right"):
		self.flip_h = false
	
	if event.is_action_pressed(&"attack") and can_attack:
		state_machine.change_state_from(
				States.ATTACKING + int(_is_sword_left), _direction)
		_is_sword_left = not _is_sword_left


func _flip(to_left: bool) -> void:
	sprite.flip_h = to_left
	hit_area.scale.x = -1 if to_left else 1


func _on_hurted(damage: int) -> void:
	super(damage)
	fx.play(&"hurt")


func _physics_process(delta: float) -> void:
	var axis := Input.get_vector(
			&"move_left", &"move_right",
			&"move_up", &"move_down",
			DEAD_ZONE)
	velocity = _change_to(axis, delta)
	_direction = axis.sign()
	
	# TODO -> make a get state function on state machine
	if state_machine.current_state == state_machine.states[States.RUNNING]:
		_play_footstep_sfx()
	
	if state_machine.is_movement_allowed():
		move_and_slide()


## Change state based on input axis. Returns a target velocity.
func _change_to(axis: Vector2, delta: float) -> Vector2:
	var target_velocity: Vector2
	if axis:
		state_machine.change_state_from(States.RUNNING)
		target_velocity = axis * speed * SPEED_MOD * delta
	else:
		state_machine.change_state_from(States.IDLE)
		target_velocity = Vector2.ZERO
	return lerp(velocity, target_velocity, weight * delta * IDEAL_FPS)


func _play_footstep_sfx() -> void:
	if footstep_interval.is_stopped():
		footstep_sfx.pitch_scale = rng.randf_range(footstep_sfx_pitch_min, footstep_sfx_pitch_max)
		footstep_sfx.play()
		footstep_interval.start()


func play_attack_sfx() -> void:
	slash_sfx.pitch_scale = rng.randf_range(
			slash_sfx_pitch_min, slash_sfx_pitch_max)
	slash_sfx.play()


@onready var aura_player: AnimationPlayer = $AuraFx/AnimationPlayer
func _on_aura_recharge() -> void:
	aura_player.play(&"cast")
