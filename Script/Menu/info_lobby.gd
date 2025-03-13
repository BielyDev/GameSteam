extends Control

@onready var SettingsLobby: PanelContainer = $vbox/Panel/Margin/Buttons/Hbox/SettingsLobby
@onready var Players: PanelContainer = $vbox/Panel/Margin/Buttons/Hbox/Players
@onready var PlayButton: Button = $vbox/Buttons/PlayButton
@onready var ReadyButton: Button = $vbox/Buttons/ReadyButton
@onready var QuitButton: Button = $vbox/Buttons/QuitButton
@onready var ID: Button = $vbox/Panel/Margin/Buttons/vbox/ID


func client_config() -> void:
	SettingsLobby.hide()
	PlayButton.hide()
	Players.show()
	ReadyButton.show()
	ID.text = str("ID ",Host.lobby_id)
	
	show()
func host_config() -> void:
	ReadyButton.hide()
	PlayButton.show()
	SettingsLobby.show()
	Players.show()
	ID.text = str("ID ",Host.lobby_id)
	show()

func _on_quit_button_pressed() -> void:
	Steam.leaveLobby(Host.lobby_id)
	Host.notif("Você saiu do lobby!")
	
	Host.request_lobby()


func _on_id_pressed() -> void:
	DisplayServer.clipboard_set(ID.text.erase(0).erase(0).erase(0))
	Host.notif("ID COPIADO")
