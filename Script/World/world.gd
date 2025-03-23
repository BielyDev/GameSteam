extends Node3D

func _ready() -> void:
	if Steam.getLobbyOwner(Lobby.lobby_id) == Host.steam_id:
		await get_tree().create_timer(5).timeout
		
		Steam.setLobbyData(Lobby.lobby_id, Host.KEY_READY, str(true))
