extends Control


func _on_cancel_pressed() -> void:
	Ui.parent_scene.get_child(0).queue_free()
func _on_quitgame_pressed() -> void:
	get_tree().quit()
