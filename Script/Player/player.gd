extends CharacterBody3D

const ACCELERATE: float = 0.2
const SPEED: float = 3.5
const RUN_SPEED: float = 7.5
const JUMP: float = 6.5
const GRAVITY: float = 0.3
const MAX_GRAVITY: int = 25

@onready var Camera: Camera3D = $Cam/Camera
@onready var Navigation: NavigationAgent3D = $Navigation
@onready var MouseRay: RayCast3D = $Cam/Camera/MouseRay

var motion: Vector3
var speed: float = 2.5
var authority: bool

func _ready() -> void:
	Camera.current = authority
	set_physics_process(authority)
	
	if !authority:
		P2P.received_position.connect(sync_pos)



func _physics_process(_delta: float) -> void:
	_moviment()
	_gravity()
	move_and_slide()

func _moviment() -> void:
	if Input.is_action_just_pressed("walk"):
		pass
	if Input.is_action_pressed("walk"):
		Navigation.target_position = MouseRay.get_collision_point()
	
	var next_position: Vector3 = global_position.direction_to(Navigation.get_next_path_position()).normalized()
	
	velocity.x = next_position.x * speed
	velocity.z = next_position.z * speed

func _gravity() -> void:
	velocity.y += -GRAVITY
	
	if is_on_floor():
		velocity.y = 0
	else:
		if velocity.y < -MAX_GRAVITY:
			velocity.y = -MAX_GRAVITY

func sync_pos(id: int, position: Vector3) -> void:
	if id == name.to_int() and !authority:
		global_position = position
