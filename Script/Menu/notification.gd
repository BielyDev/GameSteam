extends CanvasLayer

@onready var PanelNot: PanelContainer = $Notification/Panel

@onready var Tittle: Label = $Notification/Panel/HBoxContainer/Tittle
@onready var Icon: TextureRect = $Notification/Panel/HBoxContainer/Icon

func _ready() -> void:
	await create_tween().tween_property(PanelNot,"position:y",0,1).set_trans(Tween.TRANS_BACK).finished
	await get_tree().create_timer(1).timeout
	await create_tween().tween_property(PanelNot,"position:y",250,1).set_trans(Tween.TRANS_BACK).finished
	queue_free()

func start(text: String, icon: Texture2D = null) -> void:
	Tittle.text = text
	Icon.texture = icon
