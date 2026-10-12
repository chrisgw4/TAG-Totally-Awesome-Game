extends VBoxContainer
class_name LobbyMenuDevice

var lobby_menu_option_scene:PackedScene = preload("res://scenes/lobby_menu/lobby_menu_option.tscn")

@export var lobby_menu_options:Array[LobbyMenuOption]
@export var leave_lobby_option:LobbyMenuOption
@export var view_players_option:LobbyMenuOption
@export var none_option:LobbyMenuOption
@export var start_game_option:LobbyMenuOption

@export var match_scene:PackedScene

@export var screen_wiper:ScreenWiper

signal leave_lobby()

var current_lobby:String = ""

var current_players:Array[int] = []

signal start_game(scene:PackedScene)

func _ready() -> void:
	GDSync.lobby_joined.connect(_update_host)
	GDSync.client_left.connect(_update_host)
	GDSync.client_joined.connect(_update_host)
	_update_host(1)
	leave_lobby_option.clicked.connect(_request_leave_lobby)
	
	GDSync.client_joined.connect(_add_client)
	GDSync.client_left.connect(_remove_client)
	
	view_players_option.clicked.connect(_request_view_player_list)
	
	current_lobby = GDSync.lobby_get_name()
	
	none_option.label_text = "Lobby: " + current_lobby
	
	start_game_option.clicked.connect(_start_game)
	
	GDSync.change_scene_called.connect(_remove_everything)
	
	
	GDSync.expose_func(_load_level)

func _remove_everything(scene_path:String) -> void:
	print("REMOVING EVERYTHING")
	get_parent().get_parent().queue_free()



func change_level_for_all(path : String) -> void:
	if not GDSync.is_host():
		return 
	GDSync.call_func(_load_level, path)
	_load_level(path)


func _load_level(path : String) -> void:
	screen_wiper.wipe_screen()
	await screen_wiper.start_loading
	_remove_everything("")
	#await get_tree().process_frame # let old nodes (and their names) actually leave
	
	var level : Node = load(path).instantiate()
	get_tree().current_scene.add_child(level)


func _start_game() -> void:
	start_game.emit(match_scene)
	if GDSync.is_host():
		
		#screen_wiper.wipe_screen()
		#
		#await screen_wiper.start_loading
		GDSync.lobby_set_tag("started", true)
		
		#SceneHolder.start_game_for_all.emit()
		
		#GDSync.change_scene("res://scenes/levels/arena.tscn")
		change_level_for_all("res://scenes/levels/arena.tscn")
		
		#SceneHolder.change_scene_for_all.emit("res://scenes/levels/arena.tscn", get_parent().get_parent())


func _hide_options() -> void:
	$ClickPlayer.play()
	for option in lobby_menu_options:
		option.hide()

func _show_options() -> void:
	$ClickPlayer.play()
	for option in lobby_menu_options:
		option.show()
		#await get_tree().create_timer(0.1).timeout

func _remove_players() -> void:
	$ClickPlayer.play()
	for child in get_children():
		#print("NAME ", child.name)
		if "remove" in child.name:
			child.queue_free()
	_show_options()


func _request_view_player_list() -> void:
	$ClickPlayer.play()
	_hide_options()
	_refresh_players()
	
	var back_option:LobbyMenuOption = lobby_menu_option_scene.instantiate()
	back_option.label_text = "Back"
	add_child(back_option)
	back_option.name = "remove"
	back_option.clicked.connect(_remove_players)
	
	for i in current_players:
		var temp = lobby_menu_option_scene.instantiate()
		temp.label_text = str(GDSync.player_get_username(i, "Guest2"))
		add_child(temp)
		temp.name = "remove " + str(i)
		temp.hide_arrow = true


func _add_client(client_id:int) -> void:
	if client_id in current_players:
		return
	current_players.append(client_id)
	#print(current_players)
	#print(GDSync.player_get_username(client_id, "Guest2"))

func _remove_client(client_id:int) -> void:
	if client_id in current_players:
		current_players.erase(client_id)
		
		
	#print(current_players)
	#print(GDSync.player_get_username(client_id, "Guest2"))

func _on_lobby_joined(_lobby_name: String) -> void:
	_refresh_players()

func _refresh_players() -> void:
	$ClickPlayer.play()
	current_players.clear()
	for id in GDSync.lobby_get_all_clients():
		current_players.append(id)

func _request_leave_lobby() -> void:
	$ClickPlayer.play()
	leave_lobby.emit()


func _update_host(_var) -> void:
	if GDSync.is_host():
		start_game_option.modulate = Color("#FFFFFF")
	else:
		start_game_option.modulate = Color("#5e5e5e")
	_refresh_players()
	_remove_players()


func _show_players() -> void:
	pass
	GDSync.get_public_lobby("")
