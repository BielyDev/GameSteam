extends Node3D

const PLAYER = preload("res://Scene/Person/player.tscn")

@onready var Pos: Node3D = $Pos
@onready var Players: Node3D = $Players
@onready var Cam: Camera3D = $"../Settings/CamReady/Cam"


func _ready() -> void:
	P2P.new_player_in_world.connect(peer_connected)
	Lobby.exited_player.connect(peer_exited)
	
	
	Ui.alert("CARREGANDO MUNDO!")
	P2P.send_message_for_peers(false, P2P.PLAYER.ENTER_WORLD,[OK])

func new_player_in_world(_id: int) -> void:
	if _id == Host.steam_id:
		await get_tree().create_timer(1).timeout
	
	add_player(0,_id)

func add_player(_peer_number: int, _peer_id: int) -> void:
	var new_player = PLAYER.instantiate()
	
	new_player.name = str(_peer_id)
	new_player.authority = _peer_id == Host.steam_id
	
	Players.add_child(new_player)
	
	if new_player.authority:
		Cam.current = false
		new_player.global_position = Pos.get_child(_peer_number).global_position + Vector3(0,1,0)
		P2P.send_position(new_player.global_position)


func peer_connected(id: int) -> void:
	add_player(Players.get_child_count() - 1, id)

func peer_exited(id: int) -> void:
	for player: Peer in Players.get_children():
		if player.name.to_int() == id:
			player.queue_free()
