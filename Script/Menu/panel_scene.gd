extends Control

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		quit()

func _on_back_pressed() -> void:
	quit()

func quit() -> void:
	queue_free()
