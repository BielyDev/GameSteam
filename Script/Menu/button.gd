extends Button

var lobby_id: int

func _pressed() -> void:
	Steam.joinLobby(lobby_id)
