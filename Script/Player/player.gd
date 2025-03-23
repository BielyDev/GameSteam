extends Peer

const GUI = preload("res://Scene/Screen/gui.tscn")

func _ready() -> void:
	_peer_configurate()
	
	if authority:
		add_child(GUI.instantiate())


#func _process(_delta: float) -> void:
#	

func _physics_process(_delta: float) -> void:
	if authority:
		player(_delta)
	else:
		peer(_delta)
	
	move_and_slide()
