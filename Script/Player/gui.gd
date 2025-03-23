extends CanvasLayer

const MENU_GAME = preload("res://Scene/Screen/menu_game.tscn")

var MenuGame: Control

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu"):
		if is_instance_valid(MenuGame):
			MenuGame.queue_free()
			return
		
		MenuGame = Ui.new_simple_scene(MENU_GAME)
