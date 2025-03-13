extends PanelContainer

signal loaded_avatar()

const BUTTONPLAYER = preload("res://Scene/Screen/buttonplayer.tscn")

@onready var List: HBoxContainer = $Margin/Buttons/list

func refresh() -> void:
	for child in List.get_children():
		child.queue_free()
	
	Steam.avatar_loaded.connect(createPlayerLobby)
	for player in Host.players_lobby:
		Steam.getPlayerAvatar(Steam.AVATAR_LARGE, player)
		
		await loaded_avatar
	
	Steam.avatar_loaded.disconnect(createPlayerLobby)

func createPlayerLobby(_id: int, _size: int, _avatar: PackedByteArray) -> void:
	var button: Button = BUTTONPLAYER.instantiate()
	List.add_child(button)
	button.text = Steam.getFriendPersonaName(_id)
	button.Avatar.texture = Ui.readImageSteam(_size, _avatar)
	
	loaded_avatar.emit()


func _on_lobby_new_player(id: int) -> void:
	refresh()


func _on_lobby_exited_player(id: int) -> void:
	refresh()


func _on_button_pressed() -> void:
	refresh()
