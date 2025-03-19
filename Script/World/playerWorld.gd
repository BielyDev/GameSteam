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
	
	if Host.enet.get_unique_id() == 1:
		add_player(1)
	
	for peer: ENetPacketPeer in Host.enet.host.get_peers():
		Ui.alert(str("Peers ",peer))
		add_player(peer.get_instance_id())
#	

func add_player(peer_id: int) -> void:
	var new_player = PLAYER.instantiate()
	new_player.set_multiplayer_authority(peer_id)
	new_player.name = str(peer_id)
	
	Instances.add_child(new_player)
