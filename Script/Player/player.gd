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

@rpc("call_local","any_peer")
func test(id) -> void:
	Ui.alert(str(id))

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
	
	motion = motion.normalized() * speed[int(Input.is_action_pressed("run"))]
	
	velocity.x = lerp(velocity.x, motion.x, ACCELERATE)
	velocity.z = lerp(velocity.z, motion.z, ACCELERATE)


func _on_timer_timeout() -> void:
	if Input.is_action_pressed("jump"):
		#test.rpc(Host.steam_id)
		
		for player_number: int in Steam.getNumLobbyMembers(Lobby.lobby_id):
			print(Host.steam.get_peer_id_from_steam64( Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number) ))
			
			test.rpc_id(Host.steam.get_peer_id_from_steam64( Steam.getLobbyMemberByIndex(Lobby.lobby_id, player_number) ),"EEEEEUUUUU")
