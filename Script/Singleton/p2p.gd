extends Node

func _ready() -> void:
	
	Steam.p2p_session_request.connect(p2p_message)

func p2p_message() -> void:
	print("asd")
