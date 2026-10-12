extends Node2D


@export var screen_wiper:ScreenWiper

@export var color_rect:ColorRect

var main_menu_scene:PackedScene = load("res://scenes/menus/main_menu/main_menu.tscn")

@export var lobby_menu_device:LobbyMenuDevice

@export var music_player:AudioPlayer

@export var lobby_data:Dictionary = {}

signal client_joined(client_id:int)
signal client_loaded_in()
signal updated_lobby_data()

func _ready() -> void:
	#leave_button.pressed.connect(_leave_lobby)
	screen_wiper.start_loading.connect(_complete_scene_switch)
	
	lobby_data = GDSync.lobby_get_all_data()
	
	if GDSync.is_host():
		var team = GDSync.player_get_data(GDSync.get_client_id(), "team", '')
		lobby_data[team] = GDSync.get_client_id()
		print("updated team on host")
	
	screen_wiper.clear_screen_wipe()
	
	lobby_menu_device.leave_lobby.connect(_leave_lobby)
	
	music_player.volume_linear = 0
	fade_audio_in()
	
	#GDSync.client_joined.connect(_assign_client_a_team)
	GDSync.client_left.connect(_unassign_client_a_team)
	GDSync.expose_func(_client_assign_team)
	
	GDSync.expose_signal(client_joined)
	GDSync.expose_signal(client_loaded_in)
	
	client_loaded_in.connect(_sync_players)
	
	#$PlayerSpawner.player_spawned.connect(_update_player)
	client_joined.connect(_update_player)
	
	GDSync.host_changed.connect(_recount_teams)
	
	if not GDSync.is_host():
		GDSync.emit_signal_remote_on(GDSync.get_host(), client_joined, GDSync.get_client_id())
	
	GDSync.emit_signal_remote_all(client_loaded_in)
	GDSync.player_set_data("score", 0)
	
	await get_tree().create_timer(0.2).timeout
	color_rect.hide()
	color_rect.queue_free()


func _recount_teams(is_host:bool, new_host_id:int) -> void:
	lobby_data = {"Yellow":-1, "Red":-1, "Blue":-1, "Purple":-1}
	for child:Player in $PlayerSpawner.get_children():
		lobby_data[child.team] = child.name.to_int()


func _sync_players() -> void:
	($PlayerSpawner.get_node(str(GDSync.get_client_id())).prop_sync as PropertySynchronizer).synchronize(true)


func _update_player(client_id:int) -> void:
	if GDSync.is_host():
		print("YO IM THE HOST AFTER SOMEONE JOINED")
		_assign_client_a_team(client_id)
		#await updated_lobby_data
		#GDSync.lobby_set_data(lobby_data.find_key(client_id), client_id)


func _client_assign_team(client_id:int, team:String) -> void:
	GDSync.lobby_set_data(team, client_id)
	lobby_data[team] = client_id
	GDSync.player_set_data("team", team)
	print(GDSync.get_client_id())
	print("SETTING TEAM TO: ", team)
	


func _assign_client_a_team(client_id:int) -> void:
	if not GDSync.is_host():
		return
	
	var data:Dictionary = lobby_data
	print("Local Lobby Data Before: ", lobby_data)
	var teams:Array[String] = []
	if data["Purple"] == -1:
		teams.append("Purple")
	if data["Red"] == -1:
		teams.append("Red")
	if data["Yellow"] == -1:
		teams.append("Yellow")
	if data["Blue"] == -1:
		teams.append("Blue")
	
	print(teams)
	var selected_team:String = teams.pick_random()
	lobby_data[selected_team] = client_id
	updated_lobby_data.emit()
	print("Local Lobby Data After: ", lobby_data)
	
	
	GDSync.call_func_on(client_id, _client_assign_team, client_id, selected_team)
	
	await get_tree().create_timer(0.5).timeout
	print("Lobby_Data:", GDSync.lobby_get_all_data())
	pass


func _unassign_client_a_team(client_id:int) -> void:
	if not GDSync.is_host():
		_recount_teams(false, 0)
		return
	
	
	print(GDSync.player_get_all_data(client_id))
	print("Lobby Data:", GDSync.lobby_get_all_data())
	
	var data = lobby_data
	for key in data.keys():
		if data[key] == client_id:
			GDSync.lobby_set_data(key, -1)
			data[key] = -1
			print("removed client")
	
	print("Lobby Data After:", GDSync.lobby_get_all_data())



func _leave_lobby() -> void:
	if GDSync.is_host():
		lobby_data[lobby_data.find_key(GDSync.get_client_id())] = -1
	
	GDSync.lobby_leave()
	screen_wiper.wipe_screen()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 0, 1)
	tween.play()
	
	await screen_wiper.start_loading
	await tween.finished
	
	SceneHolder.change_scene_to.emit(main_menu_scene, self)
	

func _complete_scene_switch() -> void:
	pass
	#SceneHolder.change_scene_to.emit(main_menu_scene, self)


func fade_audio_in() -> void:
	music_player._replay_song()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 1.4, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()
