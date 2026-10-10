extends PanelContainer
class_name LobbySelector

@export var lobby_gatherer:LobbyGatherer

var lobby_menu_item:PackedScene = preload("res://scenes/lobby_menu/lobby_item.tscn")

@export var item_container:VBoxContainer

@export var back_menu_option:LobbyMenuOption
@export var refresh_menu_option:LobbyMenuOption

@export var timer:Timer
@export var lobby_refresh_time:float = 10

func _ready() -> void:
	lobby_gatherer._get_public_lobbies()
	lobby_gatherer.lobbies_sorted.connect(_create_lobby_items)
	
	back_menu_option.clicked.connect(_change_scene_to_lobby_menu_options)
	
	timer.timeout.connect(lobby_gatherer._get_public_lobbies)
	timer.timeout.connect(_restart_timer)
	timer.start(lobby_refresh_time)
	
	refresh_menu_option.clicked.connect(lobby_gatherer._get_public_lobbies)


func _restart_timer() -> void:
	timer.start(lobby_refresh_time)

func _change_scene_to_lobby_menu_options() -> void:
	get_parent().get_parent().change_scene_to.emit(load("res://scenes/lobby_menu/lobby_option_selector.tscn"), self)

func _populate_lobby_browser() -> void:
	pass

func _create_lobby_items(lobbies:Array) -> void:
	for child in item_container.get_children():
		if child is LobbyMenuOption:
			continue
		child.queue_free()
	
	for lobby in lobbies:
		var lobby_instance:LobbyItem = lobby_menu_item.instantiate() as LobbyItem
		lobby_instance.set_values(lobby["Name"], lobby["PlayerCount"], lobby["PlayerLimit"],lobby["HasPassword"], )
		item_container.add_child(lobby_instance)
