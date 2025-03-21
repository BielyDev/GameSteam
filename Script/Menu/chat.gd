extends PanelContainer

@onready var MessageEdit: LineEdit = $vbox/Bar/MessageEdit
@onready var Send: ButtonAnimated = $vbox/Bar/Send
@onready var Vbox: VBoxContainer = $vbox/Scroll/vbox

var image: Array = [
	preload("res://Assets/2D/Chat/Cat/cat_0.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_1.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_2.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_3.jpeg"),
	preload("res://Assets/2D/Chat/Cat/cat_4.jpg"),
]


func _ready() -> void:
	Lobby.lobby_chat.connect(_received_message)


func _commands() -> bool:
	if MessageEdit.text[0] == "/":
		var command: PackedStringArray = MessageEdit.text.split(" ")
		
		match command[0]:
			"/clear":
				for child: Node in Vbox.get_children():
					child.queue_free()
				message_commands("Chat limpo!")
				return true
			"/image":
				Lobby.send_message(Lobby.MESSAGE_LOBBY.CHAT, [MessageEdit.text])
				message_commands("Mandando imagem...")
				return true
		
		message_commands(str("O comando ",command[0]," não existe!"))
		return true
	
	return false


func _received_commands(_user_id: int, _message: String) -> bool:
	if _message[0] == "/":
		var command: PackedStringArray = _message.split(" ")
		
		match command[0]:
			"/image":
				instance_image(_user_id, int(_message[_message.length()-1]))
				
				return true
		
		return true
	return false


func message_commands(_message: String) -> void:
	instance_rich_label(str("[color=gray]",_message))

func instance_rich_label(_message: String) -> void:
	var new_rich: RichTextLabel = RichTextLabel.new()
	
	new_rich.bbcode_enabled = true
	new_rich.text = _message
	new_rich.fit_content = true
	new_rich.scroll_active = false
	
	Vbox.add_child(new_rich)

func instance_image(_user_id: int, _image: int) -> void:
	if !(_image < image.size()): return
	
	_received_message(_user_id," ")
	var new_texture: TextureRect = TextureRect.new()
	
	new_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	new_texture.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	#new_texture.stretch_mode = TextureRect.STRETCH_KEEP
	new_texture.custom_minimum_size = Vector2(100.0,100.0)
	new_texture.texture = image[_image]
	
	Vbox.add_child(new_texture)


func _received_message(_user_id: int, _message: String) -> void:
	if _received_commands(_user_id ,_message): return
	
	var nickname: String
	
	if Host.steam_id == _user_id:
		nickname = str("[color=cyan]",Steam.getPersonaName(),"[/color]: ")
	else:
		nickname = str("[color=yellow]",Steam.getFriendPersonaName(_user_id),"[/color]: ")
	
	instance_rich_label(str(nickname,_message))

func _on_send_pressed() -> void:
	if !_commands():
		Lobby.send_message(Lobby.MESSAGE_LOBBY.CHAT, [MessageEdit.text])
	
	MessageEdit.text = ""
	Send.disabled = true

func _on_message_edit_text_changed(_new_text: String) -> void:
	Send.disabled = !_new_text.length() > 0

func _on_message_edit_text_submitted(_new_text: String) -> void:
	Send.disabled = !_new_text.length() > 0
	_on_send_pressed()
