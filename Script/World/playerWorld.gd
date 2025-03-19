extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var Instances: Node3D = $Instances


func _ready() -> void:
	refresh_player()


func refresh_player() -> void:
	
	print("Host ",Host.enet)
	print("Netword ",Host.enet.host.get_peers())
	
	
	await get_tree().create_timer(2).timeout
	
	for peer_number: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		var steam_id: int = Steam.getLobbyMemberByIndex(Lobby.lobby_id, peer_number)
		var steam_peer: int = Host.steam.get_peer_id_from_steam64(steam_id)
		Ui.alert(str("Peers ",multiplayer.get_peers()))
		add_player(steam_id, steam_peer)

func add_player(steam_id: int, peer_id: int) -> void:
	var new_player = PLAYER.instantiate()
	new_player.set_multiplayer_authority(peer_id)
	new_player.name = str(peer_id)
	
	Instances.add_child(new_player)
