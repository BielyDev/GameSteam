extends PanelContainer

const BUTTON_SCRIPT = preload("res://Script/Menu/button.gd")

@onready var Server: Node = $"../../../../../../../.."
@onready var ListVbox: VBoxContainer = $VBox/Scroll/ListVbox
@onready var Lobby: PanelContainer = $"../../../../.."


func _ready() -> void:
	Steam.lobby_match_list.connect(_on_lobby_match_list)


func instance_button() -> Button:
	var _new_button = Button.new()
	
	_new_button.set_script(BUTTON_SCRIPT)
	ListVbox.add_child(_new_button)
	
	_new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	return _new_button

func delete_buttons() -> void:
	for child: Node in ListVbox.get_children():
		child.queue_free()


func _on_lobby_match_list(_id_lobbies: Array) -> void:
	delete_buttons()
	
	for _id_lobby: int in _id_lobbies:
		var _lobby_name: String = Steam.getLobbyData(_id_lobby,Server.key_name)
		
		
		var button: Button = instance_button()
		
		var _lobby_mode: String = Steam.getLobbyData(_id_lobby,"mode")
		var _lobby_size: String = str(" ",Steam.getNumLobbyMembers(_id_lobby),"/",Steam.getLobbyMemberLimit(_id_lobby))
		
		button.text = str(_lobby_mode," - ",_lobby_name,_lobby_size)

func _on_refresh_pressed() -> void:
	
	Server.request_lobby()

func _on_mode_item_selected(_index: int) -> void:
	Steam.setLobbyData(Lobby.lobby_id, "mode", Server.mode[_index])
	
