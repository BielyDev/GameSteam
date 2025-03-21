extends PanelContainer

const MAP_BUTTON = preload("res://Scene/Screen/map_button.tscn")

@onready var ListVbox: VBoxContainer = $VBox/Scroll/margin/ListVbox

func _ready() -> void:
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Host.request_lobby()

func delete_buttons() -> void:
	for child: Node in ListVbox.get_children():
		child.queue_free()


func _on_lobby_match_list(_id_lobbies: Array) -> void:
	delete_buttons()
	
	for _lobby_id: int in _id_lobbies:
		print(_lobby_id)
		var _lobby_name: String = Steam.getLobbyData(_lobby_id,Host.KEY_NAME)
		var _lobby_settings = JSON.parse_string(Steam.getLobbyData(_lobby_id,Host.KEY_SETTINGS))
		
		if _lobby_settings == null: # Apenas pra debugar
			_lobby_settings = Lobby.lobby_settings
		
		_instance_lobby_button(_lobby_id,_lobby_name,_lobby_settings)


func _instance_lobby_button(_lobby_id: int, _lobby_name: StringName, _lobby_settings: Dictionary) -> void:
	var new_button: Button = MAP_BUTTON.instantiate()
	
	ListVbox.add_child(new_button)
	
	new_button.lobby_id = _lobby_id
	new_button.adm_id = int(_lobby_settings.adm_id)
	
	new_button.Map.texture = Host.MAP[int(_lobby_settings.map)].image
	new_button.MapName.text = Host.MAP[int(_lobby_settings.map)].name
	
	new_button.Mode.text = Lobby.MODE[_lobby_settings.mode]
	new_button.Tittle.text = _lobby_name
	new_button.Number.text = str(" ",Steam.getNumLobbyMembers(_lobby_id),"/",Steam.getLobbyMemberLimit(_lobby_id))

func _on_refresh_pressed() -> void:
	Host.request_lobby()
