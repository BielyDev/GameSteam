extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var Instances: Node3D = $Instances


func _ready() -> void:
	refresh_player()


func refresh_player() -> void:
	
	await get_tree().create_timer(2).timeout
	
	for peer in Steam.getNumLobbyMembers(Lobby.lobby_id):
		var peer_id: int = Steam.getLobbyMemberByIndex(Lobby.lobby_id, peer)
		add_player(peer_id)

func add_player(peer_id: int) -> void:
	var new_player = PLAYER.instantiate()
	
	new_player.name = str(peer_id)
	new_player.authority = peer_id == Host.steam_id
	
	Instances.add_child(new_player)
