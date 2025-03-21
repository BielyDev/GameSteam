extends CharacterBody3D

const ACCELERATE: float = 0.2
const SPEED: float = 3.5
const RUN_SPEED: float = 7.5
const JUMP: float = 6.5
const GRAVITY: float = 0.3
const MAX_GRAVITY: int = 25

@onready var Camera: Camera3D = $Cam/Camera

var motion: Vector3
var speed: Array = [SPEED,RUN_SPEED]
var authority: bool

func _ready() -> void:
	P2P.received_position.connect(sync_pos)
	
	Camera.current = authority
	set_physics_process(authority)
	
	if !authority:
		Steam.sendP2PPacket(name.to_int(),var_to_bytes("OI"),Steam.P2P_SEND_RELIABLE)


func _physics_process(_delta: float) -> void:
	_moviment()
	move_and_slide()

func _moviment() -> void:
	velocity.y += -GRAVITY
	
	if velocity.y < -MAX_GRAVITY:
		velocity.y = -MAX_GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP
	
	motion = Vector3()
	
	motion.z += Input.get_axis("right","left") * Camera.global_basis.z.x
	motion.x += -Input.get_axis("right","left") * Camera.global_basis.z.z
	motion.z += -Input.get_axis("down","up") * Camera.global_basis.z.z
	motion.x += -Input.get_axis("down","up") * Camera.global_basis.z.x
	
	if motion != Vector3() and authority:
		P2P.send_position(global_position)
	
	motion = motion.normalized() * speed[int(Input.is_action_pressed("run"))]
	
	velocity.x = lerp(velocity.x, motion.x, ACCELERATE)
	velocity.z = lerp(velocity.z, motion.z, ACCELERATE)

func sync_pos(id: int, position: Vector3) -> void:
	if id != Host.steam_id:
		global_position = position
