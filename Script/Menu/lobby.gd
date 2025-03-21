extends Control

signal new_player(id: int)
signal exited_player(id: int)
signal ready_lobby(id: int, value: bool)
signal lobby_chat(id: int, message: String)

enum MESSAGE_LOBBY {
	CHAT,
	PLAY,
	READY
}

const INFO_LOBBY = preload("res://Scene/Screen/info_lobby.tscn")

var lobby_id: int
var lobby_name: String
var players_lobby: Dictionary

const MODE: Array = ["Easy","Medium","Hard"]
var lobby_settings: Dictionary = {
	"map" : 0,
	"mode" : 0,
	"host_id": 0,
	"port": 0,
}
var settings: Dictionary = {
	"map" : [0, "Name"],
}
var my_ready_lobby: bool:
	set(value):
		send_message(Lobby.MESSAGE_LOBBY.READY, [value])
		my_ready_lobby = value

func _ready() -> void:
	Steam.lobby_data_update.connect(lobby_data_update)
	Steam.lobby_chat_update.connect(lobby_chat_update)
	Steam.lobby_kicked.connect(lobby_kicked)
	Steam.lobby_joined.connect(lobby_joined)
	Steam.lobby_created.connect(lobby_created)
	Steam.lobby_message.connect(_lobby_message)
	Steam.lobby_invite.connect(lobby_invite)

func configureLobby(_lobby_id: int) -> void:
	Lobby.lobby_settings.port = Host.port
	Lobby.lobby_settings.host_id = Host.steam_id
	Lobby.players_lobby = {}
	
	#Host.steam.disconnect_peer(1,true)
	Steam.setLobbyJoinable(_lobby_id, true)
	Steam.setLobbyData(_lobby_id, Host.KEY_NAME, Lobby.lobby_name)
	Steam.setLobbyData(_lobby_id, Host.KEY_SETTINGS, JSON.stringify(Lobby.lobby_settings))

func startGame() -> void:
	Steam.sendLobbyChatMsg(Lobby.lobby_id, JSON.stringify([Lobby.MESSAGE_LOBBY.PLAY]))

func joinLobby(_lobby_id: int) -> void:
	Steam.joinLobby(_lobby_id)

func createLobby() -> void:
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 4)


func lobby_created(_result: int, _lobby_id: int) -> void:
	match _result:
		Steam.RESULT_OK:
			Ui.alert("Lobby criado!")
			configureLobby(_lobby_id)
			
			return
		Steam.RESULT_FAIL:
			Ui.alert("Expirado")
			
			return
	
	Ui.alert(str("Não foi possível criar o lobby! ERROR: ",_result))

func lobby_joined(_lobby_id: int, _permission: int, _block: bool, _responde: int) -> void:
	match _responde:
		Steam.RESULT_OK:
			
			if Lobby.lobby_id != _lobby_id:
				Lobby.lobby_id = _lobby_id
				
				if Steam.getLobbyOwner(_lobby_id) == Host.steam_id:
					var _err: int = await Host.createHost()
					
					if _err == OK:
						players_lobby[str(Host.steam_id)] = true
						
						Ui.new_scene(INFO_LOBBY)
				else:
					var read_lobby_settings = JSON.parse_string(Steam.getLobbyData(_lobby_id, Host.KEY_SETTINGS))
					
					if read_lobby_settings != null:
						Lobby.lobby_settings = JSON.parse_string(Steam.getLobbyData(_lobby_id, Host.KEY_SETTINGS))
					
					var _err: int = Host.createClient()
					
					if _err == OK:
						Ui.alert("Entrou em lobby.")
						Ui.new_scene(INFO_LOBBY)
					else:
						Ui.alert("Entrou em lobby desconhecido...")
						Ui.new_scene(INFO_LOBBY)
			return
		Steam.RESULT_FAIL:
			Ui.alert("Aconteceu algo inesperado! COD 2")
			return
		Steam.RESULT_ACCESS_DENIED:
			Ui.alert("Acesso negado!")
			return
		Steam.RESULT_CONNECT_FAILED:
			Ui.alert("Conexão falhou!")
			return
	
	Ui.alert(str("ERROR ,",_responde))



func lobby_invite(_user_invite: int, _lobby_id: int, _game: int) -> void:
	Ui.alert(str("Recebi o convite: ",_lobby_id))

func lobby_data_update(_lobby_id: int,_changed_id: int,_making_change_id: int) -> void:
	pass

func lobby_chat_update(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	match _chat_state:
		Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
			new_player.emit(_changed_id)
		Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
			exited_player.emit(_changed_id)
		Steam.CHAT_MEMBER_STATE_CHANGE_DISCONNECTED:
			exited_player.emit(_changed_id)

func lobby_kicked(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	print("State: ",_chat_state)


# MESSAGE ===================================================================================
func _lobby_message(_lobby_id: int, _user_id: int, _buffer: String, _type: int) -> void:
	match _type:
		Steam.CHAT_ENTRY_TYPE_CHAT_MSG:
			var message: Array = JSON.parse_string(_buffer)
			
			received_message(_user_id, message)

func received_message(_user_id: int, _message: Array) -> void:
	match int(_message[0]):
		Lobby.MESSAGE_LOBBY.CHAT:
			message_chat(_user_id, _message[1])
		Lobby.MESSAGE_LOBBY.READY:
			message_ready(_user_id, _message[1])
		Lobby.MESSAGE_LOBBY.PLAY:
			message_play(_message)

func send_message(_type: int, _message: Array) -> void:
	var _err_message: Array
	
	_err_message.append(_type)
	for i in _message:
		_err_message.append(i)
	
	Steam.sendLobbyChatMsg(Lobby.lobby_id, JSON.stringify(_err_message))

func message_chat(_user_id: int, _value: String) -> void:
	lobby_chat.emit(_user_id, _value)

func message_ready(_user_id: int, _value: bool) -> void:
	players_lobby[str(_user_id)] = _value
	ready_lobby.emit(_user_id,_value)

func message_play(_message: Array) -> void:
	for player in players_lobby:
		if players_lobby.get(player) == false:
			Ui.alert(str(Steam.getFriendPersonaName(int(player))," ainda não está pronto."))
			
			return
	
	Ui.alert("Iniciando partida...")
	
	Loader.pass_scene("res://Scene/Map/world.tscn")
	Ui.clear_scene()
#============================================================================================
