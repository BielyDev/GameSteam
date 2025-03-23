extends Node

signal steamConnected

@onready var Message: RichTextLabel = $Gui/Message
@onready var Menu: Control = $Gui/Menu

func _ready() -> void:
	Message.show()
	Menu.hide()
	
	Host.steamConnected.connect(_inicialize_steam)
	
	await get_tree().create_timer(1).timeout
	
	if Host.is_steam_on():
		_inicialize_steam()

func _inicialize_steam() -> void:
	Message.hide()
	Menu.show()
	steamConnected.emit()
