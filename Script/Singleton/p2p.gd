extends Node

enum PLAYER {
	POSITION
}


func _ready() -> void:
	Steam.p2p_session_request.connect(p2p_message)

func _process(delta: float) -> void:
	var events: Dictionary = Steam.readP2PPacket(1,0)
	if events.size() > 0:
		print("events: ",events)
		

func p2p_message(_user_id: int) -> void:
	print("UE",_user_id)
	print(Steam.readP2PPacket(_user_id))

func send_position(global_position: Vector3) -> void:
	send_message(PLAYER.POSITION, [global_position.x,global_position.y,global_position.z], Steam.P2P_SEND_UNRELIABLE)

func send_message(_type: int, _message: Array, _flag: int = Steam.P2P_SEND_RELIABLE, _channel: int = 0) -> void:
	var message: Array
	message.append(_type)
	
	for i in _message:
		message.append(i)
	
	Steam.sendP2PPacket(Lobby.lobby_settings.host_id, (message), _flag, _channel)
