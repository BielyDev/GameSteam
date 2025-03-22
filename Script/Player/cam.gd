extends Node3D

@export var sensi: float = 0.15

@onready var Camera: Camera3D = $Camera
@onready var MouseRay: RayCast3D = $Camera/MouseRay
@onready var Player: CharacterBody3D = $".."


func _ready() -> void:
	if !Player.authority:
		queue_free()

func _process(_delta: float) -> void:
	global_position = global_position.lerp(Player.global_position, 4 * _delta)

func _input(_event: InputEvent) -> void:
	
	if _event is InputEventMouseMotion:
		var mouse_pos: Vector3 = Camera.project_position(get_viewport().get_mouse_position(),2)
		
		MouseRay.look_at(mouse_pos)
