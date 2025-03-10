extends Node

signal steamConnected

const NOTIFICATION = preload("res://Scene/Screen/notification.tscn")

@onready var Message: RichTextLabel = $Gui/Message
@onready var Menu: Control = $Gui/Menu

var steam_id: int
var key_name: StringName = "namerr"
var mode: Array = ["Easy","Medium","Hard"]

func _ready() -> void:
	Message.show()
	Menu.hide()
	
	OS.request_permissions()
	OS.set_environment("SteamAppID","480")
	
	var _result: Dictionary = Steam.steamInit()
	
	if !Steam.isSteamRunning():
		OS.alert("Abre a steam rapaz","Game")
		get_tree().quit()
	
	steam_id = Steam.getSteamID()
	
	steamConnected.emit()
	
	await get_tree().create_timer(2).timeout
	
	Message.hide()
	Menu.show()

func _process(_delta: float) -> void:
	Steam.run_callbacks()


func request_lobby() -> void:
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.addRequestLobbyListStringFilter(key_name, "", Steam.LOBBY_COMPARISON_NOT_EQUAL)
	Steam.addRequestLobbyListStringFilter(key_name, " ", Steam.LOBBY_COMPARISON_NOT_EQUAL)
	Steam.requestLobbyList()

func notif(text: String, icon: Texture2D = null) -> void:
	var new_n = NOTIFICATION.instantiate()
	add_child(new_n)
	new_n.start(text, icon)
