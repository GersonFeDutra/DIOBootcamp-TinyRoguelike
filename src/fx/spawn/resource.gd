extends AnimatedSprite2D

const Playable := preload("res://src/characters/playable.gd")
@export var resource_type: Playable.ResourceTypes
@export var value: int = 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in $Area2D.get_overlapping_bodies():
			_collect_to(body)
			break


func _collect_to(to: Playable) -> void:
	to.add_resource(resource_type, value)
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	set_process_unhandled_input(true)
	assert(body as Playable != null,
			"body is not a playable character")


func _on_area_2d_body_exited(_body: Node2D) -> void:
	set_process_unhandled_input(false)
