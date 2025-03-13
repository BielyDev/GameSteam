extends Control

@onready var NameLobby: LineEdit = $Panel/Margin/Buttons/hbox/NameLobby
@onready var ModeLobby: OptionButton = $Panel/Margin/Buttons/hbox/ModeLobby
@onready var CreateLobby: Button = $Panel/Margin/Buttons/CreateLobby

const INFO_LOBBY = preload("res://Scene/Screen/info_lobby.tscn")


func _ready() -> void:
	Steam.lobby_created.connect(lobby_created)

func create_lobby() -> void:
	Host.steam.create_host(Host.port)
	
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 4)
	Steam.connectP2P(Host.steam_id, Host.port, {})

func lobby_created(_result: int, _lobby_id: int) -> void:
	set_disabled_buttons()
	
	match _result:
		Steam.RESULT_OK:
			Host.lobby_id = _lobby_id
			Host.lobby_settings.adm_id = Host.steam_id
			#Host.players_lobby.append(Host.steam_id)
			
			Ui.new_scene(INFO_LOBBY).host_config()
			return
		Steam.RESULT_FAIL:
			set_disabled_buttons(false)
			return
	
	Ui.notif("Não foi possível criar o lobby!")

func hide_create() -> void:
	await get_tree().create_timer(0.5).timeout # Apenas por aviso
	
	Host.notif("Lobby created")
	NameLobby.text = ""
	Host.request_lobby()
	#InfoLobby.host_config()
	hide()

func set_disabled_buttons(value: bool = true) -> void:
	NameLobby.editable = !value
	ModeLobby.disabled = value
	CreateLobby.disabled = value

func _on_create_pressed() -> void:
	create_lobby()
