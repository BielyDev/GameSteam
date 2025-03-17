extends Control

var mouse: bool
var is_lobby: bool
var id: int

@onready var AddFriend: ButtonAnimated = $vbox/AddFriend
@onready var RemoveFriend: ButtonAnimated = $vbox/RemoveFriend
@onready var SendMessage: ButtonAnimated = $vbox/SendMessage
@onready var ViewProfile: ButtonAnimated = $vbox/ViewProfile
@onready var InvinteLobby: ButtonAnimated = $vbox/InvinteLobby
@onready var CreateInvinteLobby: ButtonAnimated = $vbox/CreateInvinteLobby

func _ready() -> void:
	if Host.steam_id == id:
		AddFriend.hide()
		RemoveFriend.hide()
		SendMessage.hide()
		InvinteLobby.hide()
		CreateInvinteLobby.hide()
	
	if is_lobby:
		CreateInvinteLobby.hide()
	else:
		InvinteLobby.hide()
	
	if Steam.hasFriend(id, Steam.FRIEND_FLAG_IMMEDIATE):
		AddFriend.hide()
	else:
		RemoveFriend.hide()
		SendMessage.hide()
	
	size = Vector2()

func _input(_event: InputEvent) -> void:
	if !(_event is InputEventMouseMotion):
		if !mouse:
			await get_tree().create_timer(0.1).timeout
			queue_free()

func _on_add_friend_pressed() -> void:
	Steam.activateGameOverlayToUser("friendadd",id)
func _on_remove_friend_pressed() -> void:
	Steam.activateGameOverlayToUser("friendremove",id)
func _on_send_message_pressed() -> void:
	Steam.activateGameOverlayToUser("chat",id)
func _on_view_profile_pressed() -> void:
	Steam.activateGameOverlayToUser("stats",id)
func _on_invinte_lobby_pressed() -> void:
	Steam.inviteUserToLobby(Lobby.lobby_id, id)
func _on_create_invinte_lobby_pressed() -> void:
	Lobby.createLobby()
	await get_tree().create_timer(2).timeout
	Steam.inviteUserToLobby(Lobby.lobby_id, id)

func _on_mouse_entered() -> void:
	mouse = true
func _on_mouse_exited() -> void:
	mouse = false
