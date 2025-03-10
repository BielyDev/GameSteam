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
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 4)

func lobby_created(_result: int, _lobby_id: int) -> void:
	print("Criando um lobby...")
	set_disabled_buttons()
	
	match _result:
		Steam.RESULT_OK:
			print("Lobby criado com sucesso!")
			Lobby.lobby_id = _lobby_id
			
			print("AcceptP2PSessionWithUser: ",Steam.acceptP2PSessionWithUser(Server.steam_id))
			print("AllowP2PPacketRelay: ",Steam.allowP2PPacketRelay(true))
			
			print("SetLobbyJoinable: ",Steam.setLobbyJoinable(_lobby_id, true))
			print("SetLobbyData: ",Steam.setLobbyData(_lobby_id, Server.key_name, NameLobby.text))
			print("SetLobbyData: ",Steam.setLobbyData(_lobby_id, "mode", Server.mode[ModeLobby.selected]))
			
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
	
	Server.notif("Lobby created")
	NameLobby.text = ""
	Server.request_lobby()
	hide()
	InfoLobby.host_config()

func set_disabled_buttons(value: bool = true) -> void:
	NameLobby.editable = !value
	ModeLobby.disabled = value
	CreateLobby.disabled = value

func _on_create_pressed() -> void:
	create_lobby()
	
