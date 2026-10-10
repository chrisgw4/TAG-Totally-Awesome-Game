extends Node


var current_lobbies:Array

signal lobbies_sorted(lobbies:Array)

func _ready() -> void:
	if not GDSync.is_active():
		print("Not Active")
		return
	
	GDSync.lobbies_received.connect(_received_lobbies)


func _get_public_lobbies() -> void:
	GDSync.get_public_lobbies()


func _received_lobbies(lobbies:Array) -> void:
	current_lobbies = lobbies
	print(lobbies)
	_sort_lobbies(lobbies)


func _sort_lobbies(lobbies:Array) -> void:
	var sorted_lobby_array:Array
	for lobby in lobbies:
		# Skip closed or started lobbies
		if lobby.get("Open", true) == false:
			continue
		if lobby.get("Tags", {}).get("started", false):
			continue
		
		sorted_lobby_array.append(lobby)
	
	lobbies_sorted.emit(sorted_lobby_array)
