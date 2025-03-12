extends Node

const BUTTON_SCRIPT = preload("res://Script/Menu/button.gd")

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
