extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var Instances: Node3D = $Instances

func _ready() -> void:
	
	print(Host.steam)
	
	for player_number: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		
		var peer_id: int = Host.steam.get_peer_id_from_steam64(Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number))
		
		var new_player = PLAYER.instantiate()
		if Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number) == Host.steam_id:
			new_player.authority = true
		
		Instances.add_child(new_player)
		new_player.name = str(peer_id)
		new_player.set_multiplayer_authority(peer_id)
