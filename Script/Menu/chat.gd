extends PanelContainer

@onready var MessageEdit: LineEdit = $vbox/Bar/MessageEdit
@onready var Send: ButtonAnimated = $vbox/Bar/Send
@onready var Vbox: VBoxContainer = $vbox/Scroll/vbox

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
		
		message_commands(str("O comando ",command[0]," não existe!"))
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


func _received_message(_user_id: int, _message: String) -> void:
	var nickname: String
	
	if Host.steam_id == _user_id:
		nickname = str("[color=yellow]",Steam.getPersonaName(),"[/color]: ")
	else:
		nickname = str("[color=blue]",Steam.getFriendPersonaName(_user_id),"[/color]: ")
	
	instance_rich_label(str(nickname,_message))

func _on_send_pressed() -> void:
	if !_commands():
		Lobby.send_message(Lobby.MESSAGE_LOBBY.CHAT, [MessageEdit.text])
	
	MessageEdit.text = ""
	Send.disabled = true

func _on_message_edit_text_changed(_new_text: String) -> void:
	Send.disabled = !_new_text.length() > 0
