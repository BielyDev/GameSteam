extends Control

const LOBBIES = preload("res://Scene/Screen/lobbies.tscn")
const QUIT_GAME = preload("res://Scene/Screen/quit_game.tscn")

func _on_play_pressed() -> void:
	Ui.new_simple_scene(LOBBIES)
func _on_quit_pressed() -> void:
	Ui.new_simple_scene(QUIT_GAME)
