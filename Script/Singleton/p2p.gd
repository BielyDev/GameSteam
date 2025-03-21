extends Node

signal received_position(id: int, position: Vector3)

const LERP_POSITION: float = 0.1


enum PLAYER {
	POSITION,
	NAT
}


func _process(delta: float) -> void:
	var events: Dictionary = Steam.readP2PPacket(32,0)
	if events.size() > 0:
		
		var message: Array = bytes_to_var(events.data)
		var message_type: int = message[0]
		
		match message_type:
			PLAYER.POSITION:
				var position: Vector3 = message[1]
				
				received_position.emit(events.remote_steam_id, position)
			PLAYER.NAT:
				Ui.alert("RECEBENDO POOOOOOONGGGGGGG!!!!!!!!!!!!!")

func send_position(global_position: Vector3) -> void:
	send_message_for_peers(false , PLAYER.POSITION, [global_position], Steam.P2P_SEND_UNRELIABLE_NO_DELAY)

func send_message_for_peers(my: bool ,_type: int, _message: Array, _flag: int = Steam.P2P_SEND_RELIABLE, _channel: int = 0) -> void:
	for peer: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
		if !my:
			if peer == Host.steam_id:
				continue
		
		var player_id: int = Steam.getLobbyMemberByIndex(Lobby.lobby_id, peer)
		
		send_message(player_id, _type, _message, _flag, _channel)

func send_message(_send_player: int,_type: int, _message: Array, _flag: int = Steam.P2P_SEND_RELIABLE, _channel: int = 0) -> void:
	var message: Array = []
	message.append(_type)
	
	for i in _message:
		message.append(i)
	#print(message)
	Steam.sendP2PPacket(_send_player, var_to_bytes(message), _flag, _channel)
