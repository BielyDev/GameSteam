extends PanelContainer

@onready var SettingsLobby: PanelContainer = $Margin/Buttons/Hbox/SettingsLobby
@onready var Players: PanelContainer = $Margin/Buttons/Hbox/Players
@onready var PlayButton: Button = $Margin/Buttons/Buttons/PlayButton
@onready var ReadyButton: Button = $Margin/Buttons/Buttons/ReadyButton
@onready var QuitButton: Button = $Margin/Buttons/Buttons/QuitButton
@onready var Lobby: PanelContainer = $"../.."
@onready var InfoLobby: PanelContainer = $"."
@onready var CreateLobby: PanelContainer = $"../CreateLobby"
@onready var ID: Button = $Margin/Buttons/vbox/ID
@onready var Server: Node = $"../../../../.."


func client_config() -> void:
	SettingsLobby.hide()
	PlayButton.hide()
	Players.show()
	ReadyButton.show()
	ID.text = str("ID ",Lobby.lobby_id)
	
	show()
func host_config() -> void:
	ReadyButton.hide()
	PlayButton.show()
	SettingsLobby.show()
	Players.show()
	ID.text = str("ID ",Lobby.lobby_id)
	show()

func _on_quit_button_pressed() -> void:
	Steam.leaveLobby(Lobby.lobby_id)
	Server.notif("Você saiu do lobby!")
	CreateLobby.show()
	InfoLobby.hide()
	CreateLobby.set_disabled_buttons(false)
	
	Server.request_lobby()


func _on_id_pressed() -> void:
	DisplayServer.clipboard_set(ID.text.erase(0).erase(0).erase(0))
