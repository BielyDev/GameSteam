extends Control

@onready var Blur: ColorRect = $Blur
@onready var ColorNode: ColorRect = $Color


func pass_scene(_scene: String) -> void:
	create_tween().tween_property(Blur.material,"shader_parameter/blur_force",5,0.5)
	await create_tween().tween_property(ColorNode,"color:a",1,1).finished
	get_tree().change_scene_to_file(_scene)
	create_tween().tween_property(Blur.material,"shader_parameter/blur_force",0,1)
	create_tween().tween_property(ColorNode,"color:a",0,0.5)
