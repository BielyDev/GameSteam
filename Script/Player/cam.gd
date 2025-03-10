extends Node3D

@export var sensi: float = 0.15

@onready var Camera: Camera3D = $Camera


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(_event: InputEvent) -> void:
	
	if _event is InputEventMouseMotion:
		var mouse: Vector2 = _event.relative * sensi
		
		rotation.y += -deg_to_rad(mouse.x)
		Camera.rotation.x += -deg_to_rad(mouse.y )
		
		Camera.rotation_degrees.x = clamp(Camera.rotation_degrees.x,-80,80)
