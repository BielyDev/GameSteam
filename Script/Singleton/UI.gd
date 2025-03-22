extends CanvasLayer

enum STATUS_BUTTONFRIEND {
	FRIEND,
	PENDING,
	OFFLINE,
	AWAY,
}

const BUTTON_SCRIPT = preload("res://Script/Menu/button.gd")
const PANEL_SCENE = preload("res://Scene/Screen/panel_scene.tscn")
const NOTIFICATION = preload("res://Scene/Screen/notification.tscn")
const PROPERTY_PLAYER_BUTTON = preload("res://Scene/Screen/property_player_button.tscn")

var queue_alert: Array = []

var parent_alert: Node = Node.new()
var parent_scene: Node = Node.new()
var newProperty: Control
var FriendList: Control

func _ready() -> void:
	parent_alert.child_order_changed.connect(_call_queue_alert)
	
	layer = 2
	
	add_child(parent_alert)
	add_child(parent_scene)

func alert(_text: String, _icon: Texture2D = null) -> void:
	if parent_alert.get_child_count() > 0:
		queue_alert.append([_text, _icon])
	else:
		_instance_alert(_text, _icon)

func _instance_alert(_text: String, _icon: Texture2D = null) -> void:
	var new_alert = NOTIFICATION.instantiate()
	
	parent_alert.add_child(new_alert)
	new_alert.start(_text, _icon)

func _call_queue_alert() -> void:
	if parent_alert.get_child_count() == 0 and queue_alert.size() > 0:
		var _message: Array = queue_alert[0]
		_instance_alert(_message[0], _message[1])
		queue_alert.erase(_message)

func clear_scene() -> void:
	for child in parent_scene.get_children():
		child.queue_free()

func new_scene(_scene: PackedScene, _remove_scenes: bool = true) -> Node:
	
	if _remove_scenes:
		for child in parent_scene.get_children():
			child.queue_free()
	
	var _new_scene: Node = _scene.instantiate()
	parent_scene.add_child(_new_scene)
	
	return _new_scene

func new_simple_scene(_scene: PackedScene, _remove_scenes: bool = true) -> Node:
	
	if _remove_scenes:
		for child in parent_scene.get_children():
			child.queue_free()
	
	var new_panel = PANEL_SCENE.instantiate()
	
	var _new_scene: Node = _scene.instantiate()
	parent_scene.add_child(new_panel)
	new_panel.add_child(_new_scene)
	
	return _new_scene

func readImageSteam(_size: int, _image_byte: PackedByteArray) -> Texture:
	var _image_loader = Image.new()
	
	_image_loader.set_data(_size ,_size , false, Image.FORMAT_RGBA8, _image_byte)
	
	return ImageTexture.create_from_image(_image_loader)

func instance_button(_parent: Node) -> Button:
	var _new_button = ButtonAnimated.new()
	
	_parent.add_child(_new_button)
	
	_new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_new_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	return _new_button

func instance_button_script(_parent: Node,_script: GDScript) -> Button:
	var _new_button = ButtonAnimated.new()
	
	_new_button.set_script(_script)
	_parent.add_child(_new_button)
	
	_new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_new_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	return _new_button


func property_friend( _id: int, _position: Vector2 = get_viewport().get_mouse_position(),_is_lobby: bool = false,_is_in_lobby: bool = false) -> Control:
	if is_instance_valid(newProperty):
		newProperty.queue_free()
		return
	
	newProperty = PROPERTY_PLAYER_BUTTON.instantiate()
	newProperty.id = _id
	newProperty.is_lobby = _is_lobby
	newProperty.is_in_lobby = _is_in_lobby
	Ui.add_child(newProperty)
	
	newProperty.global_position = _position
	
	return newProperty
