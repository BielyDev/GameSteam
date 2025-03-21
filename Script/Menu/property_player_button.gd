extends Control

var mouse: bool
var is_lobby: bool
var is_in_lobby: bool
var id: int

@onready var AddFriend: ButtonAnimated = $vbox/AddFriend
@onready var RemoveFriend: ButtonAnimated = $vbox/RemoveFriend
@onready var SendMessage: ButtonAnimated = $vbox/SendMessage
@onready var ViewProfile: ButtonAnimated = $vbox/ViewProfile
@onready var InviteLobby: ButtonAnimated = $vbox/InviteLobby
@onready var CreateInviteLobby: ButtonAnimated = $vbox/CreateInviteLobby

func _ready() -> void:
	update()

func update() -> void:
	if Host.steam_id == id:
		AddFriend.hide()
		RemoveFriend.hide()
		SendMessage.hide()
		InviteLobby.hide()
		CreateInviteLobby.hide()
	
	if is_lobby:
		CreateInviteLobby.hide()
		
		if is_in_lobby:
			InviteLobby.hide()
	else:
		InviteLobby.hide()
	
	if Steam.hasFriend(id, Steam.FRIEND_FLAG_IMMEDIATE):
		AddFriend.hide()
	else:
		RemoveFriend.hide()
		SendMessage.hide()
	
	size.y = 0

func _input(_event: InputEvent) -> void:
	if !(_event is InputEventMouseMotion):
		if !mouse:
			await get_tree().create_timer(0.2).timeout
			queue_free()

func _on_add_friend_pressed() -> void:
	Steam.activateGameOverlayToUser("friendadd",id)
func _on_remove_friend_pressed() -> void:
	Steam.activateGameOverlayToUser("friendremove",id)
func _on_send_message_pressed() -> void:
	Steam.activateGameOverlayToUser("chat",id)
func _on_view_profile_pressed() -> void:
	Steam.activateGameOverlayToUser("stats",id)
func _on_invite_lobby_pressed() -> void:
	Steam.activateGameOverlayInviteDialog(Host.steam_id)
	Steam.inviteUserToLobby(Lobby.lobby_id, id)
func _on_create_invite_lobby_pressed() -> void:
	Lobby.createLobby()
	await get_tree().create_timer(2).timeout
	Host.send_invite(id)
	Steam.inviteUserToLobby(Lobby.lobby_id, id)

func _on_mouse_entered() -> void:
	mouse = true
func _on_mouse_exited() -> void:
	mouse = false
