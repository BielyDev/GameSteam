extends PanelContainer

@onready var Server: Node = $"../../.."
@onready var NameLobby: LineEdit = $Hbox/CreateLobby/Margin/Buttons/hbox/NameLobby
@onready var InfoLobby: PanelContainer = $Hbox/InfoLobby
@onready var Lobbies: PanelContainer = $Hbox/Lobbies

signal new_player(id: int)
signal exited_player(id: int)

var lobby_id: int
var settings: Dictionary = {
	"map" : [0, "Name"],
}

func _ready() -> void:
	Steam.lobby_data_update.connect(lobby_data_update)
	Steam.lobby_chat_update.connect(lobby_chat_update)
	Steam.lobby_kicked.connect(lobby_kicked)
	Steam.lobby_joined.connect(lobby_joined)
	Steam.persona_state_change.connect(persona_state_change)


func lobby_joined(_lobby_id: int, _permission: int, _block: bool, _responde: int) -> void:
	print("lobby")
	match _responde:
		Steam.RESULT_OK:
			Host.notif("Enter lobby!")
			Host.players_lobby.append(Host.steam_id)
			Lobbies.hide()
			InfoLobby.client_config()
			return
		Steam.RESULT_FAIL:
			Host.notif("Aconteceu algo inesperado! COD 2")
			return
		Steam.RESULT_ACCESS_DENIED:
			Host.notif("Acesso negado!")
			return
		Steam.RESULT_CONNECT_FAILED:
			Host.notif("Conexão falhou!")
			return
	Host.notif(str("ERROR ,",_responde))
	
	print(" - ",Steam.getNumLobbyMembers(_lobby_id)," - ",_responde)


func lobby_data_update(_lobby_id: int,_changed_id: int,_making_change_id: int) -> void:
	
	
	if _changed_id == Host.steam_id:
		print("Data")
func lobby_chat_update(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	print(_chat_state,": Fui_Chamada: ",_changed_id," - ",_making_change_id)
	match _chat_state:
		Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
			Host.players_lobby.append(_changed_id)
			new_player.emit(_changed_id)
		Steam.CHAT_MEMBER_STATE_CHANGE_LEFT or Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
			Host.players_lobby.erase(_changed_id)
			exited_player.emit(_changed_id)
	
	if _changed_id == Host.steam_id:
		print("asdasd")

func persona_state_change(_nick, _avatar) -> void:
	print(_nick, _avatar)


func lobby_kicked(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	
	if _changed_id == Host.steam_id:
		print("asdasd")
