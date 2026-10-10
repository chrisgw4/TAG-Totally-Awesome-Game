extends Node2D
class_name MainMenu

@export var screen_wiper:ScreenWiper

@export var music_player:AudioStreamPlayer

@export var color_rect:ColorRect

@export var play_button:Button
@export var sign_in_google_button:SignInWithGoogleButton

func _ready() -> void:
	if not GDSync.is_active():
		print("not activated")
	
	play_button.pressed.connect(_play_pressed)
	
	fade_audio_in()
	music_player.volume_linear = 0
	music_player.finished.connect(_loop_music)
	screen_wiper.clear_screen_wipe()
	await get_tree().create_timer(0.2).timeout
	color_rect.hide()
	color_rect.queue_free()


func _loop_music() -> void:
	music_player.play()


func _play_pressed() -> void:
	if not sign_in_google_button.logged_in:
		sign_in_google_button._sign_in_anonymously()
		await Firebase.Auth.login_succeeded
	
	screen_wiper.wipe_screen()
	
	await screen_wiper.start_loading
	
	SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_menu/old_music_device_menu.tscn"), self)



func fade_audio_in() -> void:
	music_player.play()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 1, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()


func _swipe_in() -> void:
	pass
