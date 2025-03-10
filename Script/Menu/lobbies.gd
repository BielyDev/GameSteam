extends PanelContainer

const ID_LOBBY = preload("res://Scene/Screen/id_lobby.tscn")

@onready var Gui: CanvasLayer = $"../../../.."

func _on_enter_id_pressed() -> void:
	Gui.add_child(ID_LOBBY.instantiate())
