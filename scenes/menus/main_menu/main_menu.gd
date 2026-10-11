extends Node2D
class_name MainMenu

@export var screen_wiper:ScreenWiper

@export var music_player:AudioPlayer

@export var color_rect:ColorRect

@export var sign_in_google_button:SignInWithGoogleButton

@export var main_menu_holder:MainMenuHandler

func _ready() -> void:
	if not GDSync.is_active():
		print("not activated")
	
	fade_audio_in()
	music_player.volume_linear = 0
	music_player.finished.connect(_loop_music)
	screen_wiper.clear_screen_wipe()
	await get_tree().create_timer(0.2).timeout
	color_rect.hide()
	color_rect.queue_free()
	
	main_menu_holder.play_pressed.connect(_play_pressed)
	main_menu_holder.setting_pressed.connect(_setting_pressed)
	main_menu_holder.quit_pressed.connect(_quit_game)


func _quit_game() -> void:
	GDSync.quit()

func _loop_music() -> void:
	music_player.play()


func _play_pressed() -> void:
	if not sign_in_google_button.logged_in:
		sign_in_google_button._sign_in_anonymously()
		await Firebase.Auth.login_succeeded
	
	screen_wiper.wipe_screen()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 0, 1)
	tween.play()
	
	#await screen_wiper.start_loading
	await tween.finished
	music_player.stop()
	
	SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_menu/old_music_device_menu.tscn"), self)


func _setting_pressed() -> void:
	if not sign_in_google_button.logged_in:
		sign_in_google_button._sign_in_anonymously()
		await Firebase.Auth.login_succeeded
	
	screen_wiper.wipe_screen()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 0, 1)
	tween.play()
	
	#await screen_wiper.start_loading
	await tween.finished
	music_player.stop()
	
	SceneHolder.change_scene_to.emit(preload("res://scenes/menus/settings/settings.tscn"), self)


func fade_audio_in() -> void:
	music_player._replay_song()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 1, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()


func _swipe_in() -> void:
	pass
