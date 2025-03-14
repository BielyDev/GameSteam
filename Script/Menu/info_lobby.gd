extends Control

@onready var SettingsLobby: PanelContainer = $vbox/Panel/Margin/Buttons/Hbox/SettingsLobby
@onready var Players: PanelContainer = $vbox/Panel/Margin/Buttons/Hbox/Players
@onready var PlayButton: Button = $vbox/Buttons/PlayButton
@onready var ReadyButton: Button = $vbox/Buttons/ReadyButton
@onready var QuitButton: Button = $vbox/Buttons/QuitButton
@onready var ID: Button = $vbox/Panel/Margin/Buttons/vbox/ID

const LOBBIES = preload("res://Scene/Screen/lobbies.tscn")

func _ready() -> void:
	ID.text = str("ID ",Lobby.lobby_id)

func client_config() -> void:
	SettingsLobby.hide()
	PlayButton.hide()
	ReadyButton.show()
func host_config() -> void:
	SettingsLobby.show()
	PlayButton.show()
	ReadyButton.hide()

func _on_quit_button_pressed() -> void:
	Steam.leaveLobby(Lobby.lobby_id)
	Ui.new_simple_scene(LOBBIES)
	
	Host.notif("Você saiu do lobby!")


func _on_id_pressed() -> void:
	DisplayServer.clipboard_set(ID.text.erase(0).erase(0).erase(0))
	Host.notif("ID COPIADO")
