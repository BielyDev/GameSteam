extends Node

signal steamConnected

const DEFAULT_PORT: int = 4802
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

#var steam: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var enet: ENetMultiplayerPeer
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
	steam.peer_connected.connect(peer_connected_steam)
	steamConnected.emit()
	

func peer_connected_steam(peer: int) -> void:
	print("connect_handle = ",peer)

func peer_connected(connect_handle: int, connection: Dictionary, old_state: int) -> void:
	print("connect_handle = ",connect_handle)
	print("connection = ",connection)
	print("old_state = ",old_state)

func request_lobby() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.addRequestLobbyListStringFilter(KEY_NAME, "", Steam.LOBBY_COMPARISON_NOT_EQUAL)
	Steam.requestLobbyList()

func createHost() -> int:
	enet = ENetMultiplayerPeer.new()
	var _err: int = enet.create_server(DEFAULT_PORT)#int(Lobby.lobby_settings.port)
	steam.create_host(DEFAULT_PORT)
	multiplayer.set_multiplayer_peer(steam)
	set_multiplayer_authority(enet.get_unique_id())
	enet.peer_connected.connect(peer_connected)
	return _err

func createClient(address : String, id: int) -> int:
	enet = ENetMultiplayerPeer.new()
	var _err: int = enet.create_client(address, DEFAULT_PORT)
	steam.create_client(id,DEFAULT_PORT)
	multiplayer.set_multiplayer_peer(steam)
	enet.peer_connected.connect(peer_connected)
	print("aaaaa",_err)
	return _err
