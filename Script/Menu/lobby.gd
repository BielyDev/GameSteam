extends Control

signal new_player(id: int)
signal exited_player(id: int)
signal ready_lobby(id: int, value: bool)

enum MESSAGE_LOBBY {PLAY, READY}

const INFO_LOBBY = preload("res://Scene/Screen/info_lobby.tscn")

var lobby_id: int
var lobby_name: String
var players_lobby: Dictionary

var lobby_settings: Dictionary = {
	"map" : 0,
	"mode" : 0,
	"adm_id": "",
	"port": 0,
	"ip": "",
}
var settings: Dictionary = {
	"map" : [0, "Name"],
}
var my_ready_lobby: bool:
	set(value):
		Steam.sendLobbyChatMsg(Lobby.lobby_id, JSON.stringify([Lobby.MESSAGE_LOBBY.READY, value]))
		my_ready_lobby = value

func _ready() -> void:
	Steam.lobby_data_update.connect(lobby_data_update)
	Steam.lobby_chat_update.connect(lobby_chat_update)
	Steam.lobby_kicked.connect(lobby_kicked)
	Steam.lobby_joined.connect(lobby_joined)
	Steam.lobby_created.connect(lobby_created)
	Steam.lobby_message.connect(lobby_message)
	Steam.persona_state_change.connect(persona_state_change)


func configureLobby(_lobby_id: int) -> void:
	Lobby.lobby_settings.port = Host.port
	Lobby.lobby_settings.ip = IP.get_local_addresses()
	#print(Lobby.lobby_settings.port)
	#print("Create Host: ",Host.steam.create_host(Lobby.lobby_settings.port))
	
	Steam.setLobbyJoinable(_lobby_id, true)
	Steam.setLobbyData(_lobby_id, Host.KEY_NAME, Lobby.lobby_name)
	Steam.setLobbyData(_lobby_id, Host.KEY_SETTINGS, JSON.stringify(Lobby.lobby_settings))

func startGame() -> void:
	Steam.sendLobbyChatMsg(Lobby.lobby_id, JSON.stringify([Lobby.MESSAGE_LOBBY.PLAY]))

func joinLobby(_lobby_id: int) -> void:
	Steam.joinLobby(_lobby_id)

func createLobby() -> void:
	Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, 4)
	#Steam.connectP2P(Host.steam_id, Host.port, {})

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
			#Ui.alert("Enter lobby!")
			
			if Lobby.lobby_id != _lobby_id:
				Lobby.lobby_id = _lobby_id
				
				if Steam.getLobbyOwner(_lobby_id) == Host.steam_id:
					var _err: int = Host.enet.create_server(0)#Host.steam.create_host(0)
					if _err == OK:
						multiplayer.multiplayer_peer = Host.enet
						Ui.alert(str("Host criado"))
						players_lobby[str(Host.steam_id)] = true
						Ui.new_scene(INFO_LOBBY)
				else:
					Lobby.lobby_settings = JSON.parse_string(Steam.getLobbyData(_lobby_id, Host.KEY_SETTINGS))
					var _err: int = Host.enet.create_client(Lobby.lobby_settings.ip,0)#Host.steam.create_client(_lobby_id, 0)
					if _err == OK:
						Ui.alert("Create client")
						multiplayer.multiplayer_peer = Host.enet#Host.steam
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

func persona_state_change(_nick, _avatar) -> void:
	print("persona_state_change: ",_nick, _avatar)

func lobby_kicked(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	print("State: ",_chat_state)

func lobby_message(_lobby_id: int, _user_id: int, _buffer: String, _type: int) -> void:
	print("---- ",_user_id)
	match _type:
		Steam.CHAT_ENTRY_TYPE_CHAT_MSG:
			var message: Array = JSON.parse_string(_buffer)
			
			match int(message[0]):
				Lobby.MESSAGE_LOBBY.PLAY:
					for player in players_lobby:
						if players_lobby.get(player) == false:
							Ui.alert(str(Steam.getFriendPersonaName(int(player))," ainda não está pronto."))
							
							return
					
					Ui.alert("Vai começar em...")
					for i in range(3):
						await get_tree().create_timer(1).timeout
						Ui.alert(str(3-i))
					
					Loader.pass_scene("res://Scene/Map/world.tscn")
					Ui.clear_scene()
			
				Lobby.MESSAGE_LOBBY.READY:
					players_lobby[str(_user_id)] = message[1]
					ready_lobby.emit(_user_id, message[1])
