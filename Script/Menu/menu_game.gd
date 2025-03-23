extends Control



func _on_continue_pressed() -> void:
	queue_free()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	Steam.leaveLobby(Lobby.lobby_id)
	Loader.pass_scene("res://Scene/Screen/Menu.tscn")
	Ui.clear_scene()
