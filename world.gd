@tool
extends Node2D


func _ready() -> void:
	var tile_map: TileMap = $TileMap
	var tile_rect: Rect2i = tile_map.get_used_rect()
	var tile_size: Vector2 = tile_map.tile_set.tile_size
	var extent: Vector2 = \
			Vector2(tile_rect.size) \
			* tile_size \
			- tile_size * 2.  # Remove borders
	var origin := \
			Vector2(tile_rect.position) \
			+ tile_size  # Remove borders
	_set_camera_limits(Rect2i(origin, extent))
	_set_wall_limits(Rect2(origin, extent))


func _set_camera_limits(limits: Rect2i) -> void:
	var camera: Camera2D = $Camera2D
	camera.limit_left = limits.position.x
	camera.limit_top = limits.position.y
	camera.limit_right = limits.size.x
	camera.limit_bottom = limits.size.y


func _set_wall_limits(limits: Rect2) -> void:
	$Walls/Left.position.x = limits.position.x
	$Walls/Top.position.y = limits.position.y
	$Walls/Right.position.x = limits.size.x
	$Walls/Bottom.position.y = limits.size.y
	# Centralize
	var center := limits.get_center()
	$Walls/Left.position.y = center.y
	$Walls/Top.position.x = center.x
	$Walls/Right.position.y = center.y
	$Walls/Bottom.position.x = center.x
