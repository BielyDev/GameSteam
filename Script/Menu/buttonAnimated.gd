extends Button
class_name ButtonAnimated

@export var offset_edit: bool = false

var tw: Tween 

func _draw() -> void:
	if tw != null:
		tw.stop()
	
	tw = create_tween()
	
	modulate.a = 0.3
	
	tw.tween_property(self,"modulate:a",1,0.3).set_trans(Tween.TRANS_BACK)
	
	if !offset_edit:
		pivot_offset = Vector2(size.x / 2, size.y / 2)

func _pressed() -> void:
	scale = Vector2(1.2,1.2)
	create_tween().tween_property(self,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_BACK)
