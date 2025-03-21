extends Peer



func _ready() -> void:
	_peer_configurate()


func _process(_delta: float) -> void:
	global_position = global_position.lerp(peer_position, P2P.LERP_POSITION)

func _physics_process(_delta: float) -> void:
	if authority:
		player(_delta)
	else:
		peer(_delta)
	
	move_and_slide()

func _on_send_position_timeout() -> void:
	P2P.send_position(global_position)
func _on_send_velocity_timeout() -> void:
	P2P.send_velocity(velocity)
