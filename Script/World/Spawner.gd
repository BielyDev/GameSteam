extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Pos: Node3D = $Pos
@onready var Players: Node3D = $Players


func _ready() -> void:
	refresh_player()


func refresh_player() -> void:
	
	await get_tree().create_timer(2).timeout
	
	for _peer_number: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		var _peer_id: int = Steam.getLobbyMemberByIndex(Lobby.lobby_id, _peer_number)
		add_player(_peer_number, _peer_id)

func add_player(_peer_number: int, _peer_id: int) -> void:
	var new_player = PLAYER.instantiate()
	
	new_player.name = str(_peer_id)
	new_player.authority = _peer_id == Host.steam_id
	
	Players.add_child(new_player)
	
	new_player.global_position = Pos.get_child(_peer_number).global_position + Vector3(0,1,0)
