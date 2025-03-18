extends ButtonAnimated

@onready var Avatar: TextureRect = $vbox/visual/Avatar
@onready var Name: Label = $vbox/visual/margin/text/Name
@onready var Status: Label = $vbox/visual/margin/Status
@onready var Pending: HBoxContainer = $vbox/Pending


var id: int
var status: int
var y: int = 40
var is_free: bool

var tween: Tween
var tweenSize: Tween
var tweenAvatar: Tween

func _ready() -> void:
	match status:
		Ui.STATUS_BUTTONFRIEND.FRIEND:
			Status.text = "online"
		Ui.STATUS_BUTTONFRIEND.AWAY:
			Status.text = "away"
		Ui.STATUS_BUTTONFRIEND.PENDING:
			Status.text = "pending"
			Pending.show()
			y = 90
			disabled = true
			mouse_default_cursor_shape = Control.CURSOR_ARROW
		Ui.STATUS_BUTTONFRIEND.OFFLINE:
			Status.text = "offline"
			disabled = true
			mouse_default_cursor_shape = Control.CURSOR_ARROW
	_on_mouse_exited()

func _on_pressed() -> void:
	Ui.property_friend(id, Vector2(global_position.x - 160, global_position.y))
func _on_mouse_entered() -> void:
	animation(1,y + 30)
func _on_mouse_exited() -> void:
	animation(0.4,y)


func animation(_gradient_force: float, custom_y: float) -> void:
	if tween != null:
		tween.stop()
	if tweenSize != null:
		tweenSize.stop()
	
	tween = create_tween()
	tween.tween_property(Avatar.material,"shader_parameter/gradient_force",_gradient_force,0.5).set_trans(Tween.TRANS_CUBIC)
	tweenSize = create_tween()
	tweenSize.tween_property(self,"custom_minimum_size:y",custom_y,0.5).set_trans(Tween.TRANS_CUBIC)


func _on_accept_pressed() -> void:
	Steam.activateGameOverlayToUser("friendrequestaccept",id)
func _on_decline_pressed() -> void:
	Steam.activateGameOverlayToUser("friendrequestignore",id)
