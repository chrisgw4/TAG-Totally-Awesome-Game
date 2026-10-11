extends CanvasLayer




func _ready() -> void:
	#_play_game_end()
	pass
	
	$TextureButton.pressed.connect(_load_main_menu)
	$TextureButton.mouse_entered.connect(_back_button_grow)
	$TextureButton.mouse_exited.connect(_back_button_shrink)
	


func _load_main_menu() -> void:
	var screen_wiper:ScreenWiper = $ScreenWiper
	screen_wiper.wipe_screen()
	
	GDSync.lobby_leave()
	await screen_wiper.start_loading
	
	SceneHolder.change_scene_to.emit(load("res://scenes/menus/main_menu/main_menu.tscn"), get_parent().get_parent())


func _back_button_grow() -> void:
	$TextureButton.scale = Vector2(1.15,1.15)

func _back_button_shrink() -> void:
	$TextureButton.scale = Vector2(1,1)

func _play_game_end() -> void:
	$AnimationPlayer.play("slam")
	
	await $AnimationPlayer.animation_finished
	Engine.time_scale = 1.0
	$AnimationPlayer2.play("fade")
	
	
	var best_player:Dictionary = {}
	
	for client in GDSync.lobby_get_all_clients():
		var data = GDSync.player_get_all_data(client)
		if best_player == {}:
			best_player["score"] = data["score"]
			best_player["username"] = data["Username"]
			best_player["team"] = data["team"]
		elif best_player["score"] < data["score"]:
			best_player["score"] = data["score"]
			best_player["username"] = data["Username"]
			best_player["team"] = data["team"]
	
	$Node2D/Label.text = (best_player['username'] as String).to_lower()
	$AnimationPlayer4.play((best_player['team'] as String).to_lower())
	
	await $AnimationPlayer2.animation_finished
	
	$AnimationPlayer3.play("move_in")
