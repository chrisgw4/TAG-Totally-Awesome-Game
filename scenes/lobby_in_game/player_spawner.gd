extends Node2D

# Do not forget to assign the player scene in the inspector
@export var player_scene : PackedScene

@export var player_teams:Array[String] = ["Blue", "Red", "Yellow", "Purple"]

func _ready() -> void:
	(get_tree().current_scene as CanvasLayer).follow_viewport_enabled = true
	# Still listen for changes after the game has started
	GDSync.client_joined.connect(client_joined)
	GDSync.client_left.connect(client_left)
	
	# Everyone is already in the lobby, so spawn a player for each of them
	for client_id in GDSync.lobby_get_all_clients():
		spawn_player(client_id)





func client_joined(client_id : int) -> void:
	print("Client joined ", client_id)
	spawn_player(client_id)


func spawn_player(client_id : int) -> void:
	# Guard against spawning the same player twice
	if has_node(str(client_id)):
		return
	
	var player : Player = player_scene.instantiate()
	var team = GDSync.player_get_data(client_id, "team", "")
	print("TEAM, ", team)
	player.team = team
	player.name = str(client_id)
	add_child(player)
	player.global_position = global_position
	
	# Every client sets ownership for every player, so ownership is
	# consistent everywhere
	GDSync.set_gdsync_owner(player, client_id)


func client_left(client_id : int) -> void:
	print("Client left ", client_id)
	var player : Node2D = get_node_or_null(str(client_id))
	if player != null:
		player.queue_free()
