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

#var steam: SteamMultiplayerPeer = SteamMultiplayerPeer.new()
var enet: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
var http: HTTPRequest = HTTPRequest.new()
var players: Array

func _ready() -> void:
	add_child(http)
	http.request_completed.connect(packed)
	
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
	http.request("https://api.ipify.org")
	ip = await getIpPublic
	
	var _err: int = enet.create_server(DEFAULT_PORT)
	Ui.alert(str("CreateHost: ",_err))
	multiplayer.multiplayer_peer = enet
	enet.peer_connected.connect(peer_connected)
	
	return _err

func packed(result: int, response_code: int, headers: Array, body: PackedByteArray) -> void:
	if result == OK:
		getIpPublic.emit(body.get_string_from_utf8())
	else:
		Ui.alert("Não foi possivel requisição de IP publico")


func createClient() -> int:
	print(Lobby.settings.ip)
	var _err: int = enet.create_client(Lobby.settings.ip,DEFAULT_PORT)
	Ui.alert(str("CreateClient: ",_err))
	multiplayer.multiplayer_peer = enet
	enet.peer_connected.connect(peer_connected)
	
	return _err

func peer_connected(peer: int) -> void:
	print("connect_handle = ",peer)

func connected_to_server() -> void:
	print("connected_to_server")
