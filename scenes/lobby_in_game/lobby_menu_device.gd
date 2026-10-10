extends VBoxContainer
class_name LobbyMenuDevice


@export var lobby_menu_options:Array[LobbyMenuOption]
@export var leave_lobby_option:LobbyMenuOption
@export var view_players_option:LobbyMenuOption
@export var start_game_option:LobbyMenuOption

signal leave_lobby()

var current_lobby:String = ""

var current_players:Array[int] = []

func _ready() -> void:
	GDSync.lobby_joined.connect(_update_host)
	GDSync.client_left.connect(_update_host)
	GDSync.client_joined.connect(_update_host)
	_update_host(1)
	leave_lobby_option.clicked.connect(_request_leave_lobby)
	
	GDSync.client_joined.connect(_add_client)
	GDSync.client_left.connect(_remove_client)


func _add_client(client_id:int) -> void:
	if client_id in current_players:
		return
	current_players.append(client_id)
	print(current_players)
	print(GDSync.player_get_username(client_id, "Guest2"))

func _remove_client(client_id:int) -> void:
	if client_id in current_players:
		current_players.erase(client_id)
	print(current_players)
	print(GDSync.player_get_username(client_id, "Guest2"))


func _request_leave_lobby() -> void:
	leave_lobby.emit()

func _update_host(_var) -> void:
	if GDSync.is_host():
		print("YES HOST")
	else:
		start_game_option.modulate = Color("#5e5e5e")


func _show_players() -> void:
	pass
	GDSync.get_public_lobby("")
