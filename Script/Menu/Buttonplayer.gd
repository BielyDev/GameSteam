extends ButtonAnimated


@onready var Ready: TextureRect = $Ready
@onready var NoReady: TextureRect = $NoReady
@onready var Avatar: TextureRect = $Avatar

var id: int
var tween: Tween
var tweenOpacity: Tween


var ready_lobby: bool:
	set(value):
		Ready.visible = value
		NoReady.visible = !value
		ready_lobby = value

func _ready() -> void:
	_on_mouse_exited()
	
	Lobby.ready_lobby.connect(_ready_in_player)

func _process(delta: float) -> void:
	NoReady.texture.noise.offset.y += -8 * delta


func _ready_in_player(_id: int, _value: bool) -> void:
	if id == _id:
		ready_lobby = _value

func _on_mouse_entered() -> void:
	if tween != null:
		tween.stop()
		
	tween = create_tween()
	tweenOpacity = create_tween()
	
	tween.tween_property(Avatar, "position:y", 40, 0.5).set_trans(Tween.TRANS_CUBIC)
	tweenOpacity.tween_property(Avatar.material, "shader_parameter/gradient_force", 1, 0.5).set_trans(Tween.TRANS_CUBIC)

func _on_mouse_exited() -> void:
	if tween != null:
		tween.stop()
	tween = create_tween()
	tweenOpacity = create_tween()
	tween.tween_property(Avatar, "position:y", 0, 0.5).set_trans(Tween.TRANS_CUBIC)
	tweenOpacity.tween_property(Avatar.material, "shader_parameter/gradient_force", 0.5, 0.5).set_trans(Tween.TRANS_CUBIC)


func _on_pressed() -> void:
	Ui.property_friend(id)
