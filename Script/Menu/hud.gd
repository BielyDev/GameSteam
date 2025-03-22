extends Control

@onready var Chat: PanelContainer = $Chat

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("chat"):
		Chat.visible = !Chat.visible
