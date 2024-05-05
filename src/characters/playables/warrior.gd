extends "res://src/characters/playable.gd"

## How many frames are expected in a physics_process.
## Mostly used for delta calculations with lerp.
const IDEAL_FPS = 60
const DEAD_ZONE := .15

@export_range(.001, 1.) var weight := .05  ## [fixed frames%]
var _direction := Vector2.ZERO

@onready var sprite := $AnimatedSprite2D
@onready var animation_player := $AnimationPlayer
@onready var state_machine := $StateMachine
@onready var hit_area := $HitArea


func _ready() -> void:
	if DevMode.ignore_damage:
		$HurtArea.process_mode = Node.PROCESS_MODE_DISABLED


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"move_left"):
		self.flip_h = true
	
	if event.is_action_pressed(&"move_right"):
		self.flip_h = false
	
	if event.is_action_pressed(&"attack"):
		state_machine.change_state(
				state_machine.States.ATTACKING,
				_direction)


func _flip(to_left: bool) -> void:
	sprite.flip_h = to_left
	hit_area.scale.x = -1 if to_left else 1


func _physics_process(delta: float) -> void:
	var axis := Input.get_vector(
		&"move_left", &"move_right",
		&"move_up", &"move_down",
		DEAD_ZONE)
	velocity = _change_to(axis, delta)
	_direction = axis.sign()
	
	if state_machine.is_movement_allowed():
		move_and_slide()


## Change state based on input axis. Returns a target velocity.
func _change_to(axis: Vector2, delta: float) -> Vector2:
	var target_velocity: Vector2
	if axis:
		state_machine.change_state(state_machine.States.RUNNING)
		target_velocity = axis * speed * SPEED_MOD * delta
	else:
		state_machine.change_state(state_machine.States.IDLE)
		target_velocity = Vector2.ZERO
	return lerp(velocity, target_velocity, weight * delta * IDEAL_FPS)
