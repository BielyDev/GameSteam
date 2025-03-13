extends Node

signal steamConnected

const NOTIFICATION = preload("res://Scene/Screen/notification.tscn")

const APP_ID: int = 480
const KEY_NAME: String = "namer"
const KEY_MAP_NAME: String = "map"
const KEY_SETTINGS: String = "settings"
const MODE: Array = ["Easy","Medium","Hard"]
const MAP: Array = [
	{"name" : "Bind", "image" : preload("res://Assets/2D/Background/bind.png")},
	{"name" : "Ascent", "image" : preload("res://Assets/2D/Background/mapa2.jpg")},
	{"name" : "Sunsent", "image" : preload("res://Assets/2D/Background/sunsent.jpg")}
]


var lobby_settings: Dictionary = {
	"map" : 0,
	"mode" : 0,
	"adm_id": "",
}
var lobby_id: int
var steam_id: int
var port: int = 0:
	get():
		if port == 0:
			port = randi_range(1420,9999)
		return port


var steam: SteamMultiplayerPeer = SteamMultiplayerPeer.new()

func _ready() -> void:
	OS.set_environment("SteamAppID",str(APP_ID))
	
	var _result: Dictionary = Steam.steamInit()
	
	if !Steam.isSteamRunning():
		OS.alert("Abre a steam rapaz","Game")
		get_tree().quit()
	
	steam_id = Steam.getSteamID()
	lobby_settings.adm_id = steam_id
	
	await get_tree().create_timer(1).timeout
	
	steamConnected.emit()


func joinLobby(_lobby_id: int, _port: int) -> void:
	Steam.joinLobby(_lobby_id)
	print("Connect: ",Steam.connectP2P(Steam.getLobbyOwner(_lobby_id), _port, {}))
	print(steam.create_client(_lobby_id,_port))

func peer_connected(id: int) -> void:
	print("App = ",id)

func notif(text: String, icon: Texture2D = null) -> void:
	var new_n = NOTIFICATION.instantiate()
	add_child(new_n)
	new_n.start(text, icon)

func request_lobby() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.addRequestLobbyListStringFilter(KEY_NAME, "", Steam.LOBBY_COMPARISON_NOT_EQUAL)
	Steam.addRequestLobbyListStringFilter(KEY_NAME, " ", Steam.LOBBY_COMPARISON_NOT_EQUAL)
	Steam.requestLobbyList()
