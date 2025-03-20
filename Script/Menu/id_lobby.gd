extends Control

@onready var Id: LineEdit = $vbox/id
@onready var Enter: ButtonAnimated = $vbox/Enter


func _on_id_text_changed(new_text: String) -> void:
	var save_caret: int = Id.caret_column
	Id.text = str(new_text.to_int())
	Id.caret_column = save_caret
	
	Enter.disabled = !Steam.isLobby(int(Id.text))


func _on_enter_pressed() -> void:
	Steam.joinLobby(int(Id.text))
	queue_free()
