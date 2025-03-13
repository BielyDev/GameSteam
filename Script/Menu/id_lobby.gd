extends Control

@onready var Id: LineEdit = $vbox/id
@onready var Enter: ButtonAnimated = $vbox/Enter


func _on_id_text_changed(new_text: String) -> void:
	Id.text = str(new_text.to_int())
	Enter.disabled = !Steam.isLobby(int(Id.text))


func _on_enter_pressed() -> void:
	Steam.joinLobby(int(Id.text))
	queue_free()
