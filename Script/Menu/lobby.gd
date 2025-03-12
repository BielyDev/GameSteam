extends PanelContainer

@onready var Server: Node = $"../../.."
@onready var NameLobby: LineEdit = $Hbox/CreateLobby/Margin/Buttons/hbox/NameLobby

var lobby_id: int
var settings: Dictionary = {
	"map" : [0, "Name"],
}

func _ready() -> void:
	Steam.lobby_data_update.connect(lobby_data_update)
	Steam.lobby_chat_update.connect(lobby_chat_update)
	Steam.lobby_kicked.connect(lobby_kicked)
	Steam.lobby_joined.connect(lobby_joined)


func lobby_joined(_lobby_id: int, _permission: int, _block: bool, _responde: int) -> void:
	
	match _responde:
		Steam.RESULT_OK:
			Host.notif("Enter lobby!")
			return
		Steam.RESULT_FAIL:
			Host.notif("Aconteceu algo inesperado! COD 2")
			return
		Steam.RESULT_ACCESS_DENIED:
			Host.notif("Acesso negado!")
			return
		Steam.RESULT_CONNECT_FAILED:
			Host.notif("Conexão falhou!")
			return
	Host.notif(str("ERROR ,",_responde))
	
	print(" - ",Steam.getNumLobbyMembers(_lobby_id)," - ",_responde)


func lobby_data_update(_lobby_id: int,_changed_id: int,_making_change_id: int) -> void:
	print(NameLobby.text," - ",Steam.getAllLobbyData(_lobby_id))
	
	if _changed_id == Host.steam_id:
		print("Data")
func lobby_chat_update(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	print(NameLobby.text," - ",Steam.getAllLobbyData(_lobby_id))
	
	if _changed_id == Host.steam_id:
		print("asdasd")
func lobby_kicked(_lobby_id: int,_changed_id: int,_making_change_id: int, _chat_state: int) -> void:
	
	if _changed_id == Host.steam_id:
		print("asdasd")
