extends PanelContainer

@onready var User: Button = $User
@onready var Id: Label = $User/ID

func _ready() -> void:
	Steam.avatar_loaded.connect(avatar_loaded)
	Host.steamConnected.connect(loader)

func loader() -> void:
	Steam.getPlayerAvatar(2, Host.steam_id)

func avatar_loaded(_steam_id: int, _size: int, _image_byte: PackedByteArray) -> void:
	User.icon = Ui.readImageSteam(_size, _image_byte)
	User.text = Steam.getPersonaName()
	Id.text = str(_steam_id)
	Steam.avatar_loaded.disconnect(avatar_loaded)

func _on_user_pressed() -> void:
	Steam.activateGameOverlay()

func _on_server_steam_connected() -> void:
	loader()
