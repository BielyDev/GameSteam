extends PanelContainer

@onready var Server: Node = $"../../.."
@onready var User: Button = $User

func _ready() -> void:
	Steam.avatar_loaded.connect(avatar_loaded)

func loader() -> void:
	Steam.getPlayerAvatar(2, Server.steam_id)

func avatar_loaded(_steam_id: int, _size: int, _image_byte: PackedByteArray) -> void:
	var _image_loader = Image.new()
	
	_image_loader.set_data(_size ,_size , false, Image.FORMAT_RGBA8, _image_byte)
	
	User.icon = ImageTexture.create_from_image(_image_loader)
	User.text = Steam.getPersonaName()

func _on_user_pressed() -> void:
	Steam.activateGameOverlay()

func _on_server_steam_connected() -> void:
	loader()
