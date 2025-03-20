extends Node

signal getIpPublic(ip: StringName)
signal steamConnected

const DEFAULT_PORT: int = 3247
const APP_ID: int = 480
const KEY_NAME: String = "namer"
const KEY_SETTINGS: String = "settings"
const KEY_PLAYER_LOBBY: String = "player_lobby"

const MODE: Array = ["Easy","Medium","Hard"]
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
var ip: String

var config_options: Dictionary = {
	"NETWORKING_CONFIG_FAKE_PACKET_LAG_SEND" : 4,
	"NETWORKING_CONFIG_SEND_BUFFER_SIZE": 5000,
	"NETWORKING_CONFIG_RECV_BUFFER_SIZE": 3000 
}

var players: Array
var steam: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func _ready() -> void:
	steam.peer_connected.connect(peer_connected)
	
	OS.set_environment("SteamAppID",str(APP_ID))
	OS.set_environment("SteamGameID",str(APP_ID))
	
	var _result: Dictionary = Steam.steamInit(true, APP_ID)
	
	if !Steam.isSteamRunning():
		OS.alert("Abre a steam rapaz","Game")
		get_tree().quit()
	
	steam_id = Steam.getSteamID()
	Lobby.lobby_settings.adm_id = steam_id
	
	await get_tree().create_timer(1).timeout
	
	steamConnected.emit()


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
	
	return _err

func peer_connected(peer: int) -> void:
	print("connect_handle = ",peer)

func connected_to_server() -> void:
	print("connected_to_server")
