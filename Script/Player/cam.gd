extends Node3D

@export var sensi: float = 0.15

@onready var Camera: Camera3D = $Camera
@onready var MouseRay: RayCast3D = $Camera/MouseRay
@onready var pos: MeshInstance3D = $"../Timer/pos"


func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	
	if _event is InputEventMouseMotion:
		var mouse_pos: Vector3 = Camera.project_position(get_viewport().get_mouse_position(),2)
		
		MouseRay.look_at(mouse_pos)
		pos.global_position = MouseRay.get_collision_point()
