extends Control

@onready var NameLobby: LineEdit = $Panel/Margin/Buttons/hbox/NameLobby
@onready var ModeLobby: OptionButton = $Panel/Margin/Buttons/hbox/ModeLobby
@onready var CreateLobby: Button = $Panel/Margin/Buttons/CreateLobby


func create_lobby() -> void:
	Lobby.lobby_name = NameLobby.text
	
	Host.steam.create_host(Host.port)
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 4)
	Steam.connectP2P(Host.steam_id, Host.port, {})


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
	create_lobby()
