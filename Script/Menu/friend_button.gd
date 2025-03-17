extends ButtonAnimated

@onready var Avatar: TextureRect = $Avatar
@onready var Name: Label = $margin/text/Name
@onready var Status: Label = $margin/Status

var id: int

var tween: Tween
var tweenSize: Tween
var tweenAvatar: Tween



func _on_pressed() -> void:
	Ui.property_friend(id)
func _on_mouse_entered() -> void:
	animation(1,60)
func _on_mouse_exited() -> void:
	animation(0.4,40)


func animation(_gradient_force: float, custom_y: float) -> void:
	if tween != null:
		tween.stop()
	if tweenSize != null:
		tweenSize.stop()
	
	tween = create_tween()
	tween.tween_property(Avatar.material,"shader_parameter/gradient_force",_gradient_force,0.5).set_trans(Tween.TRANS_CUBIC)
	tweenSize = create_tween()
	tweenSize.tween_property(self,"custom_minimum_size:y",custom_y,0.5).set_trans(Tween.TRANS_CUBIC)
