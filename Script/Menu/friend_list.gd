extends PanelContainer

@onready var VboxOnline: VBoxContainer = $Margin/vbox/List/Scroll/margin/vbox/Online/info/margin/VboxOnline
@onready var VboxOffline: VBoxContainer = $Margin/vbox/List/Scroll/margin/vbox/Offline/info/margin/VboxOffline


func _ready() -> void:
	Host.steamConnected.connect(_server_steam_connected)

func _server_steam_connected() -> void:
	for friend in Steam.getUserSteamFriends():
		match friend.status:
			Steam.PERSONA_STATE_ONLINE:
				add_friend(friend, VboxOnline)
			Steam.PERSONA_STATE_OFFLINE:
				var button: Button = add_friend(friend, VboxOffline)
				button.set("theme_override_colors/font_color",Color.DIM_GRAY)
				button.set("theme_override_colors/icon_hover_color",Color.DIM_GRAY)
			#Steam.PERSONA_STATE_SNOOZE and Steam.PERSONA_STATE_BUSY:
			#	add_friend(friend)


func add_friend(_friend_info: Dictionary,_parent: Node) -> Button:
	var button: Button = Ui.instance_button(_parent)
	
	button.theme_type_variation = "ButtonFriend"
	button.text = _friend_info.name
	button.custom_minimum_size.y = 26
	
	return button
