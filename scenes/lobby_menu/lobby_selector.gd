extends PanelContainer
class_name LobbySelector

@export var lobby_gatherer:LobbyGatherer

func _ready() -> void:
	lobby_gatherer._get_public_lobbies()

func _populate_lobby_browser() -> void:
	pass
