extends Control

@onready var Cam: Node3D = $InventoryPanel/view/subView/Cam
@onready var InventoryPanel: PanelSlot = $InventoryPanel

func _ready() -> void:
	InventoryPanel.columns_grid = 2
	InventoryPanel.horizontal_separation = 1
	InventoryPanel.vertical_separation = 1
	
	create_tween().tween_property(InventoryPanel,"columns_grid",0,0.5).set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property(InventoryPanel,"horizontal_separation",3.5,0.5).set_trans(Tween.TRANS_CUBIC)
	create_tween().tween_property(InventoryPanel,"vertical_separation",2.0,0.5).set_trans(Tween.TRANS_CUBIC)

func _process(delta: float) -> void:
	Cam.global_position = Index.player.global_position
