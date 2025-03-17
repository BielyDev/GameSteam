extends PanelContainer

signal loader_friend_on()
signal loader_friend_off()

const FRIEND_BUTTON = preload("res://Scene/Screen/friend_button.tscn")

@onready var VboxOnline: VBoxContainer = $Margin/vbox/List/Scroll/margin/vbox/Online/info/margin/VboxOnline
@onready var VboxOffline: VBoxContainer = $Margin/vbox/List/Scroll/margin/vbox/Offline/info/margin/VboxOffline

var now_parent: Node
var now_friend_info: Dictionary

var on: bool

func _ready() -> void:
	Host.steamConnected.connect(_server_steam_connected)
	

func _server_steam_connected() -> void:
	for friend in Steam.getUserSteamFriends():
		await get_tree().create_timer(0.1).timeout
		
		Steam.avatar_loaded.connect(createPlayerLobby)
		match friend.status:
			Steam.PERSONA_STATE_ONLINE:
				on = true
				
				add_friend(friend, VboxOnline)
				
				await loader_friend_on
			Steam.PERSONA_STATE_OFFLINE:
				on = false
				add_friend(friend, VboxOffline)
				
				await loader_friend_off
			#Steam.PERSONA_STATE_SNOOZE and Steam.PERSONA_STATE_BUSY:
			#	add_friend(friend)
		
		Steam.avatar_loaded.disconnect(createPlayerLobby)


func add_friend(_friend_info: Dictionary,_parent: Node) -> void:
	now_parent = _parent
	now_friend_info = _friend_info
	Steam.getPlayerAvatar(Steam.AVATAR_LARGE,_friend_info.id)


func createPlayerLobby(_id: int, _size: int, _avatar: PackedByteArray) -> void:
	var button = FRIEND_BUTTON.instantiate()
	button.id = _id
	now_parent.add_child(button)
	button.Name.text = now_friend_info.name
	button.Avatar.texture = Ui.readImageSteam(_size,_avatar)
	
	if on:
		button.Status.text = "online"
		
		loader_friend_on.emit()
	else:
		loader_friend_off.emit()
	#button.theme_type_variation = "ButtonFriend"
	#button.text = _friend_info.name
	#button.custom_minimum_size.y = 26
	
	
