extends Person

class_name Peer

var authority: bool
var peer_position: Vector3
var next_peer_position: Vector3

var SendPosition: Timer = Timer.new()
var SendVelocity: Timer = Timer.new()

@export var Camera: Camera3D

func peer(_delta: float) -> void:
	_moviment(_delta, next_peer_position)
	print(next_peer_position)
	_gravity()

func player(_delta: float) -> void:
	_moviment(_delta, _controller())
	_gravity()
	
	#SendVelocity.paused = !((velocity.x < -0.1 or velocity.x > 0.1) or (velocity.z < -0.1 or velocity.z > 0.1))

func _peer_configurate() -> void:
	Camera.current = authority
	set_process(!authority)
	
	if !authority:
		P2P.received_position.connect(_on_received_position)
		P2P.received_velocity.connect(_on_received_velocity)
	else:
		_configurate_timers()
		
		P2P.send_message_for_peers(false , P2P.PLAYER.POSITION, [global_position], Steam.P2P_SEND_UNRELIABLE_NO_DELAY)

func _configurate_timers() -> void:
	add_child(SendPosition)
	add_child(SendVelocity)
	
	SendPosition.wait_time = 0.5
	SendVelocity.wait_time = 0.05
	SendPosition.paused = false
	SendVelocity.paused = false
	
	SendPosition.start()
	SendVelocity.start()
	
	SendPosition.timeout.connect(_on_send_position_timeout)
	SendVelocity.timeout.connect(_on_send_velocity_timeout)


func is_peer(_id: int) -> bool:
	return _id == name.to_int() and !authority


func _on_received_position(_id: int, _position: Vector3) -> void:
	if is_peer(_id):
		global_position = peer_position
		#global_position = global_position.lerp(peer_position, P2P.LERP_POSITION)
		#peer_position = _position
func _on_received_velocity(_id: int, _velocity: Vector3) -> void:
	if is_peer(_id):
		next_peer_position = _velocity

func _on_send_position_timeout() -> void:
	P2P.send_position(global_position)
func _on_send_velocity_timeout() -> void:
	P2P.send_velocity(velocity)
