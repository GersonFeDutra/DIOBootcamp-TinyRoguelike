extends AnimatedSprite2D

const Playable := preload("res://src/characters/playable.gd")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in $Area2D.get_overlapping_bodies():
			_collect_to(body)
			get_viewport().set_input_as_handled()
			break


func _collect_to(to: Playable) -> void:
	to.add_resource()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	set_process_unhandled_input(true)
	assert(body as Playable != null,
			"body is not a playable character")


func _on_area_2d_body_exited(_body: Node2D) -> void:
	set_process_unhandled_input(false)
