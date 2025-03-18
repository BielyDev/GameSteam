extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var Instances: Node3D = $Instances


func _ready() -> void:
	refresh_player()

func refresh_player() -> void:
	
	
	await get_tree().create_timer(2).timeout
	Ui.alert(str(Host.enet.host.get_peers()," - ",Host.enet.get_unique_id()," - ",Host.enet.get_connection_status(),"\n",
		multiplayer.multiplayer_peer.get_packet_peer()
	))
	
	for player_number in Host.enet.host.get_peers():
		print(player_number)
	#	
	#	var peer_id: int = steam.get_peer_id_from_steam64(Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number))
	#	print(Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number))
	#	var new_player = PLAYER.instantiate()
	#	if Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number) == Host.steam_id:
	#		new_player.authority = true
		
		#Instances.add_child(new_player)
		#new_player.name = str(peer_id)
		#new_player.set_multiplayer_authority(peer_id)
		
		#print(Host.steam.gnew_player.name.to_int()))
