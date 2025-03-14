extends ButtonAnimated

var lobby_id: int
var adm_id: int

var tween: Tween
var tweenSize: Tween
var tweenAvatar: Tween

@onready var Map: TextureRect = $Map
@onready var Mode: Label = $margin/text/Mode
@onready var Tittle: Label = $margin/text/Tittle
@onready var Number: Label = $margin/text/Number
@onready var MapName: Label = $margin/MapName
@onready var Adm: Label = $margin/Avatar/Adm
@onready var AdmAvatar: TextureRect = $margin/Avatar

func _ready() -> void:
	_on_mouse_exited()

func loader_adm() -> void:
	Steam.avatar_loaded.connect(avatar_loader)
	
	Adm.text = str(Steam.getFriendPersonaName(adm_id)," ")
	Steam.getPlayerAvatar(Steam.AVATAR_MEDIUM, adm_id)

func _pressed() -> void:
	Host.joinLobby(lobby_id, Host.port)

func avatar_loader(_user_id: int, _size: int, _image_byte: PackedByteArray) -> void:
	AdmAvatar.texture = Ui.readImageSteam(_size, _image_byte)
	Steam.avatar_loaded.disconnect(avatar_loader)

func _on_mouse_entered() -> void:
	animation(1, 90, 1)
	loader_adm()

func _on_mouse_exited() -> void:
	animation(0.4, 50, 0)

func animation(_gradient_force: float, custom_y: float, modulate_a: float) -> void:
	if tween != null:
		tween.stop()
	if tweenSize != null:
		tweenSize.stop()
	
	tween = create_tween()
	tween.tween_property(Map.material,"shader_parameter/gradient_force",_gradient_force,0.5).set_trans(Tween.TRANS_CUBIC)
	tweenSize = create_tween()
	tweenSize.tween_property(self,"custom_minimum_size:y",custom_y,0.5).set_trans(Tween.TRANS_CUBIC)
	tweenAvatar = create_tween()
	tweenAvatar.tween_property(AdmAvatar,"modulate:a",modulate_a,0.5).set_trans(Tween.TRANS_CUBIC)
