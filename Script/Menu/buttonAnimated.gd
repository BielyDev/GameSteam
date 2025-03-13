extends Button
class_name ButtonAnimated

@export var offset_edit: bool = false
@export var enable_x: bool = true
@export var enable_y: bool = true

@export var scale_max: float = 1.05

var tw: Tween 
var twScale: Tween 

func _ready() -> void:
	mouse_entered.connect(mouse_enter)
	mouse_exited.connect(mouse_exit)
	button_up.connect(on_up)
	button_down.connect(on_down)

func mouse_enter() -> void:
	if disabled: return
	transparency()
	change_scale(scale_max)
func mouse_exit() -> void:
	if disabled: return
	transparency()
	change_scale(1)
func on_up() -> void:
	transparency()
	change_scale(1)
func on_down() -> void:
	transparency()
	change_scale(0.8)


func transparency() -> void:
	if tw != null:
		tw.stop()
	tw = create_tween()
	modulate.a = 0.5
	tw.tween_property(self,"modulate:a",1,0.3).set_trans(Tween.TRANS_CUBIC)
	

func change_scale(_size: float = 1.0) -> void:
	
	if twScale != null:
		twScale.stop()
	twScale = create_tween()
	
	var scale_edit: Vector2 = Vector2(1,1)
	
	if enable_x: scale_edit.x = _size
	if enable_y: scale_edit.y = _size
	
	twScale.tween_property(self,"scale",scale_edit,0.3).set_trans(Tween.TRANS_CUBIC)
	
	if !offset_edit:
		pivot_offset = Vector2(size.x / 2, size.y / 2)

func _pressed() -> void:
	if enable_x: scale.x = scale_max * 1.2
	if enable_y: scale.y = scale_max * 1.2
	
	create_tween().tween_property(self,"scale:x",1,0.3).set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property(self,"scale:y",1,0.3).set_trans(Tween.TRANS_CUBIC)
