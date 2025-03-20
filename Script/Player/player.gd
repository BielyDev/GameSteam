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
	Camera.current = authority
	set_physics_process(authority)


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
	
	if motion != Vector3():
		sync_pos.rpc(Host.steam_id,global_position)
	
	motion = motion.normalized() * speed[int(Input.is_action_pressed("run"))]
	
	velocity.x = lerp(velocity.x, motion.x, ACCELERATE)
	velocity.z = lerp(velocity.z, motion.z, ACCELERATE)

@rpc("call_remote")
func sync_pos(id: int, position: Vector3) -> void:
	if id != Host.steam_id:
		global_position = position
