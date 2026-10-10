extends PanelContainer
class_name LobbyOptionSelector

@export var lobby_browser:LobbyMenuOption
@export var create_lobby:LobbyMenuOption
@export var join_lobby:LobbyMenuOption

func _ready() -> void:
	lobby_browser.clicked.connect(_change_to_lobby_browser)
	create_lobby.clicked.connect(_change_to_create_lobby)
	join_lobby.clicked.connect(_change_to_join_lobby)


func _change_to_lobby_browser() -> void:
	SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_menu/lobby_selector.tscn"), self)

func _change_to_create_lobby() -> void:
	pass

func _change_to_join_lobby() -> void:
	pass
