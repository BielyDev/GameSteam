extends Node3D

@export var item_id: int
@export var amount: int

@onready var Model: Node3D = $Model

func _ready() -> void:
	InventoryFile.search_item_id()
	
	var new_item = item_scene.instantiate()
	
	Model.add_child(new_item)


func _on_area_body_entered(body: Node3D) -> void:
	Inventory.add_item(1,item_id,amount)
