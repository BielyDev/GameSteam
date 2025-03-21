extends Node

class_name Effect

const CURSOR_DIRECTION = preload("res://Scene/Effect/cursor_direction.tscn")


static func cursor_direction(_position: Vector3) -> void:
	var new_cursor = CURSOR_DIRECTION.instantiate()
	Index.add_child(new_cursor)
	new_cursor.global_position = _position
