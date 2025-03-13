extends PanelContainer

const MAP_BUTTON = preload("res://Scene/Screen/map_button.tscn")

@onready var Server: Node = $"../../../../../../../.."
@onready var ListVbox: VBoxContainer = $VBox/Scroll/margin/ListVbox
@onready var Lobby: PanelContainer = $"../../../../.."


func _ready() -> void:
	Steam.lobby_match_list.connect(_on_lobby_match_list)


func delete_buttons() -> void:
	for child: Node in ListVbox.get_children():
		child.queue_free()


func _on_lobby_match_list(_id_lobbies: Array) -> void:
	delete_buttons()
	
	for _id_lobby: int in _id_lobbies:
		var _lobby_name: String = Steam.getLobbyData(_id_lobby,Host.KEY_NAME)
		var _lobby_settings = JSON.parse_string(Steam.getLobbyData(_id_lobby,Host.KEY_SETTINGS))
		
		if _lobby_settings == null: # Apenas pra debugar
			_lobby_settings = Host.lobby_settings
		
		var new_button: Button = MAP_BUTTON.instantiate()
		ListVbox.add_child(new_button)
		
		new_button.Map.texture = Host.MAP[int(_lobby_settings.map)].image
		new_button.MapName.text = Host.MAP[int(_lobby_settings.map)].name
		
		var _lobby_mode: String = Steam.getLobbyData(_id_lobby,"mode")
		var _lobby_size: String = str(" ",Steam.getNumLobbyMembers(_id_lobby),"/",Steam.getLobbyMemberLimit(_id_lobby))
		#Steam.getLobbyMemberData(_id_lobby,)
		
		new_button.lobby_id = _id_lobby
		new_button.adm_id = _lobby_settings.adm_id
		print(" --a- ",_lobby_settings.adm_id)
		print(Host.steam_id)
		
		new_button.Mode.text = _lobby_mode
		new_button.Tittle.text = _lobby_name
		new_button.Number.text = _lobby_size

func _on_refresh_pressed() -> void:
	Host.request_lobby()

func _on_mode_item_selected(_index: int) -> void:
	Steam.setLobbyData(Lobby.lobby_id, "mode", Host.MODE[_index])
	
