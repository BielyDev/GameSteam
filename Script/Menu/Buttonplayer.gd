extends ButtonAnimated

var tween: Tween

@onready var Avatar: TextureRect = $Avatar

func _on_mouse_entered() -> void:
	if tween != null:
		tween.stop()
	tween = create_tween()
	tween.tween_property(Avatar, "position:y", 40, 0.5).set_trans(Tween.TRANS_BACK)
func _on_mouse_exited() -> void:
	if tween != null:
		tween.stop()
	tween = create_tween()
	tween.tween_property(Avatar, "position:y", 0, 0.5).set_trans(Tween.TRANS_BACK)
