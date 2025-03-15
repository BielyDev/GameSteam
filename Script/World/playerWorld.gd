extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var Instances: Node3D = $Instances

func _ready() -> void:
	for player_number: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		
		print(Host.steam.get_peer_id_from_steam64(Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number)))
		print(Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number))
		var new_player = PLAYER.instantiate()
		if Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number) == Host.steam_id:
			new_player.authority = true
		
		Instances.add_child(new_player)
