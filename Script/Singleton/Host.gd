extends Node

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

var steam: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var players: Array

func _ready() -> void:
	OS.set_environment("SteamAppID",str(APP_ID))
	
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
	var _err: int = steam.create_host(DEFAULT_PORT)
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.multiplayer_peer = steam
	
	return _err

func createClient() -> int:
	var _err: int = steam.create_client(steam_id, DEFAULT_PORT)
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.connected_to_server.connect(connected_to_server)	
	multiplayer.multiplayer_peer = steam
	
	return _err

func peer_connected(peer: int) -> void:
	print("connect_handle = ",peer)

func connected_to_server() -> void:
	print("connected_to_server")
