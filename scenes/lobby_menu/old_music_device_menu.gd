extends CanvasLayer

signal change_scene_to(scene:PackedScene, object)

@export var box_container:FlowContainer
@export var color_rect:ColorRect
@export var screen_wiper:ScreenWiper

@export var music_player:AudioPlayer

func _ready() -> void:
	change_scene_to.connect(_change_scene)
	
	screen_wiper.clear_screen_wipe()
	fade_audio_in()
	music_player.volume_linear = 0
	
	await get_tree().create_timer(0.2).timeout
	color_rect.hide()
	
	GDSync.lobby_joined.connect(_clear_scene_tree)
	
	
	#music_player.play()
	music_player.finished.connect(_restart_music)


func _restart_music() -> void:
	music_player.play()

func _clear_scene_tree(_lobby_name:String) -> void:
	
	screen_wiper.wipe_screen()
	
	var tween = create_tween()
	tween.tween_property(
		music_player, "volume_linear", 0, 1
	)
	tween.play()
	
	await screen_wiper.start_loading
	await tween.finished
	
	if GDSync.is_host():
		var teams:Array[String] = []
		if GDSync.lobby_get_data("Purple") == -1:
			teams.append("Purple")
		if GDSync.lobby_get_data("Red") == -1:
			teams.append("Red")
		if GDSync.lobby_get_data("Yellow") == -1:
			teams.append("Yellow")
		if GDSync.lobby_get_data("Blue") == -1:
			teams.append("Blue")
		
		print(teams)
		var selected_team:String = teams.pick_random()
	
	
		GDSync.lobby_set_data(selected_team, GDSync.get_client_id())
		GDSync.player_set_data("team", selected_team)
	print("New Lobby Data", GDSync.lobby_get_all_data())
	
	
	music_player.stop()
	queue_free()
	SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_in_game/lobby_scene.tscn"), self)


func _change_scene(scene:PackedScene, object) -> void:
	box_container.add_child(scene.instantiate())
	object.queue_free()
	


func fade_audio_in() -> void:
	music_player._replay_song()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 1, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()


func _change_to_main_menu() -> void:
	
	screen_wiper.wipe_screen()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 0, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()
	
	await screen_wiper.start_loading
	await tween.finished
	music_player.stop()
	
	SceneHolder.change_scene_to.emit(load("res://scenes/menus/main_menu/main_menu.tscn"), self)
