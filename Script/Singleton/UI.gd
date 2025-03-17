extends CanvasLayer

const BUTTON_SCRIPT = preload("res://Script/Menu/button.gd")
const PANEL_SCENE = preload("res://Scene/Screen/panel_scene.tscn")
const NOTIFICATION = preload("res://Scene/Screen/notification.tscn")
const PROPERTY_PLAYER_BUTTON = preload("res://Scene/Screen/property_player_button.tscn")

var parent_scene: Control = Control.new()
var newProperty: Control
var FriendList: Control

func _ready() -> void:
	layer = 2
	
	add_child(parent_scene)
	parent_scene.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent_scene.size = get_viewport().size

func alert(text: String, icon: Texture2D = null) -> void:
	var new_n = NOTIFICATION.instantiate()
	add_child(new_n)
	new_n.start(text, icon)

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


func property_friend( _id: int, _position: Vector2 = get_viewport().get_mouse_position()) -> void:
	if is_instance_valid(newProperty):
		newProperty.queue_free()
		return
	
	newProperty = PROPERTY_PLAYER_BUTTON.instantiate()
	newProperty.id = _id
	Ui.add_child(newProperty)
	
	newProperty.global_position = _position
