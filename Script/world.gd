extends Node

signal steamConnected

@onready var Message: RichTextLabel = $Gui/Message
@onready var Menu: Control = $Gui/Menu

func _ready() -> void:
	Message.show()
	Menu.hide()
	
	Host.steamConnected.connect(_inicialize_steam)

func _inicialize_steam() -> void:
	Message.hide()
	Menu.show()
	steamConnected.emit()

func _process(_delta: float) -> void:
	Steam.run_callbacks()
