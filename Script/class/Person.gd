extends CharacterBody3D

class_name Person

const ACCELERATE: float = 0.2
const SPEED: float = 3.5
const RUN_SPEED: float = 7.5
const JUMP: float = 6.5
const GRAVITY: float = 0.3
const MAX_GRAVITY: int = 25

var speed: float = 2.5

@export var RayMouse: RayCast3D
@export var Navigation: NavigationAgent3D

func _moviment(_delta: float, _next_position: Vector3) -> void:
	velocity.x = 0
	velocity.z = 0
	
	velocity.x = _next_position.x
	velocity.z = _next_position.z
	_rotation(velocity, _delta)

func _controller() -> Vector3:
	if Input.is_action_just_pressed("walk"):
		Effect.cursor_direction(RayMouse.get_collision_point() + Vector3(0,0.1,0))
	if Input.is_action_pressed("walk"):
		Navigation.target_position = RayMouse.get_collision_point()
	
	return global_position.direction_to(Navigation.get_next_path_position()).normalized() * speed


func _gravity() -> void:
	velocity.y += -GRAVITY
	
	if is_on_floor():
		velocity.y = 0
	else:
		if velocity.y < -MAX_GRAVITY:
			velocity.y = -MAX_GRAVITY

func _rotation(_vector: Vector3, _delta: float) -> void:
	var dir: Vector2 = Vector2(_vector.z,_vector.x)
	
	rotation.y = lerp_angle(rotation.y, dir.angle(), 15 * _delta)
