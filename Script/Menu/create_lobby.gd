extends PanelContainer

@onready var Server: Node = $"../../../../.."
@onready var Lobby: PanelContainer = $"../.."
@onready var NameLobby: LineEdit = $Margin/Buttons/hbox/NameLobby
@onready var ModeLobby: OptionButton = $Margin/Buttons/hbox/ModeLobby
@onready var CreateLobby: Button = $Margin/Buttons/CreateLobby
@onready var InfoLobby: PanelContainer = $"../InfoLobby"



func _ready() -> void:
	Steam.lobby_created.connect(lobby_created)

func create_lobby() -> void:
	Host.enet.create_server(Host.port, 4)
	
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 4)
	Steam.connectP2P(Host.steam_id, Host.port, {})

func lobby_created(_result: int, _lobby_id: int) -> void:
	print("Criando um lobby...")
	set_disabled_buttons()
	
	match _result:
		Steam.RESULT_OK:
			print("Lobby criado com sucesso!")
			Lobby.lobby_id = _lobby_id
			
			print("AcceptP2PSessionWithUser: ",Steam.acceptP2PSessionWithUser(Host.steam_id))
			print("AllowP2PPacketRelay: ",Steam.allowP2PPacketRelay(true))
			
			print("SetLobbyJoinable: ",Steam.setLobbyJoinable(_lobby_id, true))
			print("SetLobbyData: ",Steam.setLobbyData(_lobby_id, Host.KEY_NAME, NameLobby.text))
			print("SetLobbyData: ",Steam.setLobbyData(_lobby_id, Host.KEY_MAP_NAME, NameLobby.text))
			print("SetLobbyData: ",Steam.setLobbyData(_lobby_id, "owner_name", Steam.getPersonaName()))
			print("SetLobbyData: ",Steam.setLobbyData(_lobby_id, Host.KEY_SETTINGS, JSON.stringify(Host.lobby_settings)))
			print("SetLobbyData: ",Steam.setLobbyData(_lobby_id, "mode", Host.MODE[ModeLobby.selected]))
			
			hide_create()
			return
		Steam.RESULT_FAIL:
			set_disabled_buttons(false)
			print("Não foi possivel criar o lobby!")
			print("Erro desconhecido!")
			return
	
	print("Não foi possivel criar o lobby!")
	print("Erro numero: ",_result)

func hide_create() -> void:
	await get_tree().create_timer(0.5).timeout # Apenas por aviso
	
	Host.notif("Lobby created")
	NameLobby.text = ""
	Host.request_lobby()
	InfoLobby.host_config()
	hide()

func set_disabled_buttons(value: bool = true) -> void:
	NameLobby.editable = !value
	ModeLobby.disabled = value
	CreateLobby.disabled = value

func _on_create_pressed() -> void:
	create_lobby()
