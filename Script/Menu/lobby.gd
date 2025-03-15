extends Control

signal new_player(id: int)
signal exited_player(id: int)

const INFO_LOBBY = preload("res://Scene/Screen/info_lobby.tscn")

var lobby_name: String
var lobby_id: int
var lobby_settings: Dictionary = {
	"map" : 0,
	"mode" : 0,
	"adm_id": "",
}
var settings: Dictionary = {
	"map" : [0, "Name"],
}

func _ready() -> void:
	Steam.lobby_data_update.connect(lobby_data_update)
	Steam.lobby_chat_update.connect(lobby_chat_update)
	Steam.lobby_kicked.connect(lobby_kicked)
	Steam.lobby_joined.connect(lobby_joined)
	Steam.lobby_created.connect(lobby_created)
	Steam.persona_state_change.connect(persona_state_change)


func configureLobby(_lobby_id: int) -> void:
	Steam.setLobbyJoinable(_lobby_id, true)
	Steam.setLobbyData(_lobby_id, Host.KEY_NAME, Lobby.lobby_name)
	Steam.setLobbyData(_lobby_id, Host.KEY_SETTINGS, JSON.stringify(Lobby.lobby_settings))


func joinLobby(_lobby_id: int, _port: int) -> void:
	Steam.joinLobby(_lobby_id)
	print("connectP2P: ",Steam.connectP2P(Steam.getLobbyOwner(_lobby_id), _port, {}))
	print("create_client: ",Host.steam.create_client(_lobby_id,_port))

func lobby_created(_result: int, _lobby_id: int) -> void:
	
	match _result:
		Steam.RESULT_OK:
			configureLobby(_lobby_id)
			Lobby.lobby_settings.adm_id = str(Steam.getSteamID())
			
			return
		Steam.RESULT_FAIL:
			Ui.notif("Expirado")
			
			return
	
	Ui.notif("Não foi possível criar o lobby! ERROR: ",_result)

func lobby_joined(_lobby_id: int, _permission: int, _block: bool, _responde: int) -> void:
	
	match _responde:
		Steam.RESULT_OK:
			Host.notif("Enter lobby!")
			
			if Lobby.lobby_id != _lobby_id:
				Lobby.lobby_id = _lobby_id
				
				if Steam.getLobbyOwner(_lobby_id) == Host.steam_id:
					Ui.new_scene(INFO_LOBBY).host_config()
				else:
					Lobby.lobby_settings = JSON.parse_string(Steam.getLobbyData(_lobby_id, Host.KEY_SETTINGS))
					Ui.new_scene(INFO_LOBBY).client_config()
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

func lobby_data_update(_lobby_id: int,_changed_id: int,_making_change_id: int) -> void:
	pass

func lobby_chat_update(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	match _chat_state:
		Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
			Host.players_lobby.append(_changed_id)
		Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
			exited_player.emit(_changed_id)
		Steam.CHAT_MEMBER_STATE_CHANGE_DISCONNECTED:
			exited_player.emit(_changed_id)

func persona_state_change(_nick, _avatar) -> void:
	print(_nick, _avatar)

func lobby_kicked(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	print("State: ",_chat_state)
