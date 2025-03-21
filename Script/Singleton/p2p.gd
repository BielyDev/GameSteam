extends Node

func _ready() -> void:
	Steam.p2p_session_request.connect(p2p_message)

func _process(delta: float) -> void:
	var events: Dictionary = Steam.readP2PPacket(0)
	if events.size() > 0:
		print(events)

func p2p_message(_user_id: int) -> void:
	print("UE",_user_id)
	print(Steam.readP2PPacket(_user_id))
