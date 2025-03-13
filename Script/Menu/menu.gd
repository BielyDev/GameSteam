extends Control

const LOBBIES = preload("res://Scene/Screen/lobbies.tscn")

func _on_play_pressed() -> void:
	Ui.new_simple_scene(LOBBIES)
func _on_quit_pressed() -> void:
	get_tree().quit()
