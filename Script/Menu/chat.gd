extends PanelContainer

@onready var MessageEdit: LineEdit = $vbox/Bar/MessageEdit
@onready var Send: ButtonAnimated = $vbox/Bar/Send
@onready var Vbox: VBoxContainer = $vbox/Scroll/Background/vbox
@onready var Scroll: ScrollContainer = $vbox/Scroll
@onready var Hidecase: Timer = $hidecase
@onready var Bar: HBoxContainer = $vbox/Bar

@export var use_showcase: bool:
	set(value):
		use_showcase = value
		if use_showcase:
			if !is_instance_valid(Hidecase):
				await ready
			showcase()
		else:
			showcase()

var image: Array = [
	preload("res://Assets/2D/Chat/Cat/cat_0.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_1.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_2.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_3.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_4.jpg"),
	preload("res://Assets/2D/Chat/Cat/cat_5.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_6.jpg"),
	preload("res://Assets/2D/Chat/Cat/cat_7.jpg"),
	preload("res://Assets/2D/Chat/Cat/cat_8.jpg"),
	preload("res://Assets/2D/Chat/Cat/cat_9.png"),
]
var tween: Tween


func _ready() -> void:
	Lobby.lobby_chat.connect(_received_message)
	
	if use_showcase: Hidecase.start()


func _commands() -> bool:
	if MessageEdit.text[0] == "/":
		var command: PackedStringArray = MessageEdit.text.split(" ")
		
		match command[0]:
			"/help":
				message_commands(str("/clear\n/image (number) 0/",image.size(),"\n/tenor gif_name"))
				return true
			"/clear":
				for child: Node in Vbox.get_children():
					child.queue_free()
				message_commands("Chat limpo!")
				return true
			"/image":
				Lobby.send_message(Lobby.MESSAGE_LOBBY.CHAT, [MessageEdit.text])
				message_commands("Mandando imagem...")
				return true
			"/tenor":
				Lobby.send_message(Lobby.MESSAGE_LOBBY.CHAT, [MessageEdit.text])
				message_commands("Mandando gif...")
				return true
		
		message_commands(str("O comando ",command[0]," não existe! /help"))
		return true
	
	return false

func _received_commands(_user_id: int, _message: String) -> bool:
	if _message[0] == "/":
		var command: PackedStringArray = _message.split(" ")
		
		match command[0]:
			"/image":
				instance_image(_user_id, int(_message[_message.length()-1]))
				
				return true
			"/tenor":
				
				instance_gif(_user_id, command[1])
				
				return true
		
		return true
	return false

func showcase() -> void:
	if tween != null:
		tween.stop()
	
	Hidecase.start(0)
	create_tween().tween_property(Scroll,"modulate:a",1,0.3).set_trans(Tween.TRANS_BACK)

func message_commands(_message: String) -> void:
	instance_rich_label(str("[color=gray]",_message))

func instance_rich_label(_message: String) -> void:
	var new_rich: RichTextLabel = RichTextLabel.new()
	
	new_rich.bbcode_enabled = true
	new_rich.text = _message
	new_rich.fit_content = true
	new_rich.scroll_active = false
	
	Vbox.add_child(new_rich)
	
	await get_tree().create_timer(0.2).timeout
	Scroll.scroll_vertical += 500

func instance_image(_user_id: int, _image: int) -> void:
	if !(_image < image.size()): return
	
	_received_message(_user_id," ")
	var new_texture: TextureRect = TextureRect.new()
	
	new_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_texture.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	
	new_texture.custom_minimum_size = Vector2(100.0,100.0)
	new_texture.texture = image[_image]
	
	Vbox.add_child(new_texture)
	
	await get_tree().create_timer(0.2).timeout
	Scroll.scroll_vertical += 500

func instance_gif(_user_id: int, _key: String) -> void:
	if _key.length() == 0: return
	
	_received_message(_user_id," ")
	
	var new_texture: TextureRect = TextureRect.new()
	
	new_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	
	new_texture.custom_minimum_size = Vector2(300.0,200.0)
	new_texture.texture = await Request.get_image_tenor(_key)
	
	Vbox.add_child(new_texture)
	
	await get_tree().create_timer(0.2).timeout
	Scroll.scroll_vertical += 500

func _received_message(_user_id: int, _message: String) -> void:
	if use_showcase: showcase()
	
	if _received_commands(_user_id ,_message): return
	
	var nickname: String
	
	if Host.steam_id == _user_id:
		nickname = str("[color=cyan]",Steam.getPersonaName(),"[/color]: ")
	else:
		nickname = str("[color=yellow]",Steam.getFriendPersonaName(_user_id),"[/color]: ")
	
	instance_rich_label(str(nickname,_message))

func submit() -> void:
	if MessageEdit.text.length() > 0:
		_on_send_pressed()

func _on_send_pressed() -> void:
	if !_commands():
		Lobby.send_message(Lobby.MESSAGE_LOBBY.CHAT, [MessageEdit.text])
	
	MessageEdit.text = ""
	Send.disabled = true

func _on_message_edit_text_changed(_new_text: String) -> void:
	Send.disabled = !_new_text.length() > 0

func _on_message_edit_text_submitted(_new_text: String) -> void:
	submit()


func _on_hidecase_timeout() -> void:
	if use_showcase:
		tween = create_tween()
		tween.tween_property(Scroll,"modulate:a",0,5).set_trans(Tween.TRANS_CUBIC)
