extends HBoxContainer

@onready var ImageMap: Control = $Image


var selected: int:
	set(value):
		if value == -1:
			value = 2
		if value == 3:
			value = 0
		
		selected = value
		Lobby.lobby_settings.map = selected

func animate(idx: int, value: float) -> void:
	var image: TextureRect = ImageMap.get_child(idx)
	
	create_tween().tween_property(image.material,"shader_parameter/x",value,0.2)

func _on_back_pressed() -> void:
	animate(selected ,1.0)
	selected += -1
	animate(selected ,0.0)
	ImageMap.get_child(selected).material.set("shader_parameter/x",-1.0)

func _on_front_pressed() -> void:
	animate(selected ,-1.0)
	selected += 1
	animate(selected ,0.0)
	ImageMap.get_child(selected).material.set("shader_parameter/x",1.0)
