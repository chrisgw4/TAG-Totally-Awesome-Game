extends PanelContainer
class_name LobbyOptionSelector

@export var lobby_browser:LobbyMenuOption
@export var create_lobby:LobbyMenuOption
@export var join_lobby:LobbyMenuOption
@export var back_button:LobbyMenuOption

@export var screen_wiper:ScreenWiper

func _ready() -> void:
	lobby_browser.clicked.connect(_change_to_lobby_browser)
	create_lobby.clicked.connect(_change_to_create_lobby)
	join_lobby.clicked.connect(_change_to_join_lobby)
	back_button.clicked.connect(_change_to_main_menu)


func _change_to_lobby_browser() -> void:
	get_parent().get_parent().change_scene_to.emit(preload("res://scenes/lobby_menu/lobby_selector.tscn"), self)

func _change_to_create_lobby() -> void:
	get_parent().get_parent().change_scene_to.emit(preload("res://scenes/lobby_menu/lobby_creator_menu.tscn"), self)

func _change_to_join_lobby() -> void:
	pass

func _change_to_main_menu() -> void:
	
	screen_wiper.wipe_screen()
	
	await screen_wiper.start_loading
	
	SceneHolder.change_scene_to.emit(load("res://scenes/menus/main_menu/main_menu.tscn"), get_parent().get_parent())
