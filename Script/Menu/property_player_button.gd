extends Popup

var id: int

func _on_add_friend_pressed() -> void:
	Steam.requestFriendRichPresence(id)
	#
	pass
func _on_send_message_pressed() -> void:
	Steam.replyToFriendMessage(id,"oiiiiii")


func _on_popup_hide() -> void:
	queue_free()
