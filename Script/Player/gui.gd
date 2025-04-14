extends CanvasLayer

const INVENTORY = preload("res://Scene/Screen/inventory.tscn")

var inventory: bool

@onready var Hud: Control = $HUD

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory = !inventory
		update_visible()
		
		if inventory:
			Ui.new_simple_scene(INVENTORY)
		else:
			Ui.clear_scene()

func update_visible() -> void:
	Hud.FriendList.visible = false
	Hud.Chat.Bar.visible = false
	
	Index.player.move = !inventory
