extends ButtonAnimated

class_name ButtonVisible

@export var NodeVisible: Control

const ARROW_UP = preload("res://Assets/2D/arrow_up.png")
const ARROW_DOWN = preload("res://Assets/2D/arrow_down.png")

func _ready() -> void:
	update_icon()

func _pressed() -> void:
	NodeVisible.visible = !NodeVisible.visible
	update_icon()

func update_icon() -> void:
	if NodeVisible.visible:
		icon = ARROW_DOWN
	else:
		icon = ARROW_UP
