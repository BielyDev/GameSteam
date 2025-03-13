extends ButtonAnimated

var tween: Tween
var tweenOpacity: Tween

@onready var Avatar: TextureRect = $Avatar

func _ready() -> void:
	_on_mouse_exited()

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
