extends PanelContainer

signal loader_friend()


const FRIEND_BUTTON = preload("res://Scene/Screen/friend_button.tscn")


@onready var VboxOnline: VBoxContainer = $Margin/vbox/List/Scroll/margin/vbox/Online/info/margin/VboxOnline
@onready var VboxOffline: VBoxContainer = $Margin/vbox/List/Scroll/margin/vbox/Offline/info/margin/VboxOffline
@onready var VboxRecent: VBoxContainer = $Margin/vbox/List/Scroll/margin/vbox/Recent/info/margin/VboxOnline

var now_parent: Node
var now_friend_info: Dictionary

var now_status: int

func _ready() -> void:
	Host.steamConnected.connect(_server_steam_connected)
	Ui.FriendList = self



func _on_update_timeout() -> void:
	_server_steam_connected()


func _server_steam_connected() -> void:
	set_free()
	
	await get_tree().create_timer(1).timeout
	
	for friend in Steam.getUserSteamFriends():
		await get_tree().create_timer(0.05).timeout
		Steam.avatar_loaded.connect(createPlayerLobby)
		
		match friend.status:
			Steam.PERSONA_STATE_ONLINE:
				if Steam.hasFriend(friend.id, Steam.FRIEND_FLAG_IMMEDIATE):
					now_status = Ui.STATUS_BUTTONFRIEND.FRIEND
					add_friend(friend, VboxOnline)
				else:
					now_status = Ui.STATUS_BUTTONFRIEND.RECENT
					add_friend(friend, VboxRecent)
				
				await loader_friend
			Steam.PERSONA_STATE_OFFLINE:
				now_status = Ui.STATUS_BUTTONFRIEND.OFFLINE
				add_friend(friend, VboxOffline)
				await loader_friend
		
		Steam.avatar_loaded.disconnect(createPlayerLobby)


func add_friend(_friend_info: Dictionary,_parent: Node) -> void:
	now_parent = _parent
	now_friend_info = _friend_info
	Steam.getPlayerAvatar(Steam.AVATAR_LARGE,_friend_info.id)

func createPlayerLobby(_id: int, _size: int, _avatar: PackedByteArray) -> void:
	var button_child: Button = now_parent.get_node_or_null(str(_id))
	
	if button_child == null:
		var button = FRIEND_BUTTON.instantiate()
		
		button.id = _id
		button.status = now_status
		now_parent.add_child(button)
		button.name = str(_id)
		button.Name.text = now_friend_info.name
		button.Avatar.texture = Ui.readImageSteam(_size,_avatar)
		
		loader_friend.emit()
	else:
		button_child.is_free = false
		loader_friend.emit()

func set_free() -> void:
	for child in VboxOnline.get_children():
		if child.is_free:
			child.queue_free()
		else:
			child.is_free = true
	for child in VboxOffline.get_children():
		if child.is_free:
			child.queue_free()
		else:
			child.is_free = true
	for child in VboxRecent.get_children():
		if child.is_free:
			child.queue_free()
		else:
			child.is_free = true
