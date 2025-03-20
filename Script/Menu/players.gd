extends PanelContainer

signal loaded_avatar()

const BUTTONPLAYER = preload("res://Scene/Screen/buttonplayer.tscn")

@onready var List: HBoxContainer = $Margin/Buttons/list
@onready var InfoLobby: Control = $"../../../../../.."


func _ready() -> void:
	Lobby.new_player.connect(new_player)
	Lobby.exited_player.connect(exit_player)
	
	refresh()

func new_player(_id: int) -> void:
	refresh()
func exit_player(_id: int) -> void:
	refresh()

func refresh() -> void:
	for child in List.get_children():
		child.queue_free()
	
	Steam.avatar_loaded.connect(createPlayerLobby)
	for player_number: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		Steam.setPlayedWith(player_number)
		Steam.getPlayerAvatar(Steam.AVATAR_LARGE, Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number))
		await loaded_avatar
	Steam.avatar_loaded.disconnect(createPlayerLobby)
	
	if Steam.getLobbyOwner(Lobby.lobby_id) == Host.steam_id:
		InfoLobby.host_config()
	else:
		InfoLobby.client_config()

func createPlayerLobby(_id: int, _size: int, _avatar: PackedByteArray) -> void:
	var button: Button = BUTTONPLAYER.instantiate()
	List.add_child(button)
	button.id = _id
	button.text = Steam.getFriendPersonaName(_id)
	button.Avatar.texture = Ui.readImageSteam(_size, _avatar)
	
	loaded_avatar.emit()

func _on_button_pressed() -> void:
	refresh()
