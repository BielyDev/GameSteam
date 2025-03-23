extends Control

@onready var Chat: PanelContainer = $Social/Chat
@onready var Social: Control = $Social
@onready var FriendList: PanelContainer = $Social/FriendList

var item_visible: bool = false

func _ready() -> void:
	update_visible()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("chat"):
		item_visible = !item_visible
		
		if item_visible:
			Chat.MessageEdit.grab_focus()
			Chat.MessageEdit.grab_click_focus()
		else:
			Chat.submit()
		
		update_visible()

func update_visible() -> void:
	FriendList.visible = item_visible
	Chat.Bar.visible = item_visible
	
	Chat.use_showcase = !item_visible
	Index.player.move = !item_visible
