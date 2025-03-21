extends Node

signal received_position(id: int, position: Vector3)

enum PLAYER {
	POSITION
}


func _ready() -> void:
	Steam.p2p_session_request.connect(p2p_message)

func _process(delta: float) -> void:
	var events: Dictionary = Steam.readP2PPacket(0,0)
	if events.size() > 0:
		print("events: ",events)
		
		var message_type: int = events.data[0]
		
		match message_type:
			PLAYER.POSITION:
				var position: Vector3 = Vector3(events.data[1],events.data[2],events.data[3])
				
				received_position.emit(events.remote_steam_id, position)

func p2p_message(_user_id: int) -> void:
	print("UE",_user_id)
	print(Steam.readP2PPacket(_user_id))

func send_position(global_position: Vector3) -> void:
	for peer: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		var player_id: int = Steam.getLobbyMemberByIndex(Lobby.lobby_id, peer)
		
		send_message(player_id, PLAYER.POSITION, [global_position.x,global_position.y,global_position.z], Steam.P2P_SEND_UNRELIABLE_NO_DELAY)

func send_message(_send_player: int,_type: int, _message: Array, _flag: int = Steam.P2P_SEND_RELIABLE, _channel: int = 0) -> void:
	var message: Array = []
	message.append(_type)
	
	#for i in _message:
	#	message.append(i)
	message.append(int(_message[0]))
	message.append(int(_message[1]))
	message.append(int(_message[2]))
	print("NE: ", message)
	Steam.sendP2PPacket(_send_player, message, _flag, _channel)
