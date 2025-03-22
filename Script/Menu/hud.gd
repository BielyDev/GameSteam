extends Control

@onready var Chat: PanelContainer = $Social/Chat
@onready var Social: Control = $Social

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("chat"):
		Social.visible = !Social.visible
