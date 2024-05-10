extends Node2D

var _total_weight: float
var rng := RandomNumberGenerator.new()
var timer: Timer

@export var path_follow: PathFollow2D
@export var spawns: Array[Spawn]
@export_range(0.01, 10.0, 0.01, "or_greater")
var frequency: float = 1.0 ## Frequency of spawns [amount/sec]


func _ready() -> void:
	rng.randomize()
	
	@warning_ignore("shadowed_variable")
	for spawn in spawns:
		_total_weight += spawn.random_weight
	
	timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(spawn)
	add_child(timer, false, Node.INTERNAL_MODE_FRONT)


func spawn() -> void:
	var next: Node = get_next().scene.instantiate()
	
	path_follow.progress_ratio = rng.randf()
	next.global_position = path_follow.global_position
	
	add_child(next)


## Get a next random spawn based on the random weight of each.
func get_next() -> Spawn:
	var rand_zone: float = rng.randf() * _total_weight
	var current: Spawn
	var count: float
	
	@warning_ignore("shadowed_variable")
	for spawn in spawns:
		if rand_zone <= count + spawn.random_weight:
			current = spawn
			break
		count += spawn.random_weight
	
	return current


func set_frequency(to: float) -> void:
	timer.wait_time = to