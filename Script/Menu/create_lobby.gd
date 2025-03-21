extends Control

@onready var NameLobby: LineEdit = $Panel/Margin/Buttons/hbox/NameLobby
@onready var ModeLobby: OptionButton = $Panel/Margin/Buttons/hbox/ModeLobby
@onready var CreateLobby: Button = $Panel/Margin/Buttons/CreateLobby



func hide_create() -> void:
	await get_tree().create_timer(0.5).timeout # Apenas por aviso
	
	Host.notif("Lobby created")
	NameLobby.text = ""
	hide()

func set_disabled_buttons(value: bool = true) -> void:
	NameLobby.editable = !value
	ModeLobby.disabled = value
	CreateLobby.disabled = value

func _on_create_pressed() -> void:
	if NameLobby.text == "":
		NameLobby.text = "Lobby_sem_nome"
	Lobby.lobby_name = NameLobby.text
	
	Lobby.createLobby()
