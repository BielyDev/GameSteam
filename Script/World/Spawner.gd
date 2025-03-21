extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Pos: Node3D = $Pos
@onready var Players: Node3D = $Players


func _ready() -> void:
	refresh_player()
	Ui.alert("ENVIANDO PIIIINNNGG!")
	P2P.send_message_for_peers(false, P2P.PLAYER.NAT,[OK])


func refresh_player() -> void:
	var _players: Array
	
	for _peer_number: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		_players.append(Steam.getLobbyMemberByIndex(Lobby.lobby_id, _peer_number))
	
	_players.sort()
	
	for _player: int in _players.size():
		var _peer_id: int = Steam.getLobbyMemberByIndex(Lobby.lobby_id, _player)
		add_player(_player, _peer_id)

func add_player(_peer_number: int, _peer_id: int) -> void:
	await get_tree().create_timer(5).timeout
	
	var new_player = PLAYER.instantiate()
	
	new_player.name = str(_peer_id)
	new_player.authority = _peer_id == Host.steam_id
	
	Players.add_child(new_player)
	
	new_player.global_position = Pos.get_child(_peer_number).global_position + Vector3(0,1,0)
	
	if new_player.authority:
		P2P.send_position(new_player.global_position)
