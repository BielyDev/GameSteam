extends Control

const ID_LOBBY = preload("res://Scene/Screen/id_lobby.tscn")
const CREATE_LOBBY = preload("res://Scene/Screen/create_lobby.tscn")

func _on_enter_id_pressed() -> void:
	Ui.new_simple_scene(ID_LOBBY)
func _on_create_pressed() -> void:
	Ui.new_simple_scene(CREATE_LOBBY)
