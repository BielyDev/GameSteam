extends PanelContainer

@onready var Server: Node = $"../../.."

var lobby_id: int

func _ready() -> void:
	Steam.lobby_data_update.connect(lobby_data_update)
	Steam.lobby_chat_update.connect(lobby_chat_update)
	Steam.lobby_kicked.connect(lobby_kicked)
	Steam.lobby_joined.connect(lobby_joined)

func lobby_joined(_lobby_id: int, _permission: int, _block: bool, _responde: int) -> void:
	Server.notif("Enter lobby!")

func lobby_data_update(_lobby_id: int,_changed_id: int,_making_change_id: int) -> void:
	print(_changed_id)
	if _changed_id == Server.steam_id:
		print("asdasd")
func lobby_chat_update(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	if _changed_id == Server.steam_id:
		print("asdasd")
func lobby_kicked(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	if _changed_id == Server.steam_id:
		print("asdasd")
