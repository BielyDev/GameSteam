extends Node

signal getIpPublic(ip: StringName)
signal steamConnected

enum MESSAGE {
	INVITE
}

const DEFAULT_PORT: int = 3247
const APP_ID: int = 480
const KEY_NAME: String = "namer"
const KEY_SETTINGS: String = "settings"
const KEY_PLAYER_LOBBY: String = "player_lobby"


const MAP: Array = [
	{"name" : "Bind", "image" : preload("res://Assets/2D/Background/bind.png")},
	{"name" : "Ascent", "image" : preload("res://Assets/2D/Background/mapa2.jpg")},
	{"name" : "Sunsent", "image" : preload("res://Assets/2D/Background/sunsent.jpg")}
]


var steam_id: int
var port: int = 0:
	get():
		if port == 0:
			port = randi_range(1420,9999)
		return port

var config_options: Dictionary = {
	"NETWORKING_CONFIG_FAKE_PACKET_LAG_SEND" : 4,
	"NETWORKING_CONFIG_SEND_BUFFER_SIZE": 5000,
	"NETWORKING_CONFIG_RECV_BUFFER_SIZE": 3000 
}

var players: Array
var steam: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func _ready() -> void:
	Steam.network_messages_session_request.connect(network_messages_session_request)
	steam.peer_connected.connect(peer_connected)
	
	OS.set_environment("SteamAppID",str(APP_ID))
	OS.set_environment("SteamGameID",str(APP_ID))
	
	var _result: Dictionary = Steam.steamInit(true, APP_ID)
	
	if !Steam.isSteamRunning():
		OS.alert("Abre a steam rapaz","Teu pai")
		get_tree().quit()
	else:
		if !Steam.loggedOn():
			OS.alert("Steam desconectada!","Teu pai")
			get_tree().quit()
	
	steam_id = Steam.getSteamID()
	Lobby.lobby_settings.adm_id = steam_id
	
	await get_tree().create_timer(1).timeout
	
	steamConnected.emit()


func _process(_delta: float) -> void:
	var events: Array = Steam.receiveMessagesOnChannel(0,5)
	if events != []:
		print(events)


func request_lobby() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.addRequestLobbyListStringFilter(KEY_NAME, "", Steam.LOBBY_COMPARISON_NOT_EQUAL)
	Steam.requestLobbyList()

func createHost() -> int:
	
	if Steam.acceptP2PSessionWithUser(steam_id):
		return OK
	
	return FAILED

func createClient() -> int:
	var _err: int = Steam.connectP2P(Steam.getLobbyOwner(Lobby.lobby_id),DEFAULT_PORT,{})
	print("Owner: ",Steam.getLobbyOwner(Lobby.lobby_id))
	return OK

func send_invite(_id: int) -> void:
	Steam.sendMessageToUser(_id, [Host.MESSAGE.INVITE,Lobby.lobby_id,Host.steam_id],0,0)

func network_messages_session_request(_id: int) -> void:
	print(_id)
	Steam.acceptSessionWithUser(_id)

func peer_connected(peer: int) -> void:
	print("connect_handle = ",peer)

func connected_to_server() -> void:
	print("connected_to_server")
