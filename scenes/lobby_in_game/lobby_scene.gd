extends Node2D


@export var screen_wiper:ScreenWiper

@export var color_rect:ColorRect

var main_menu_scene:PackedScene = load("res://scenes/menus/main_menu/main_menu.tscn")

@export var lobby_menu_device:LobbyMenuDevice

@export var music_player:AudioStreamPlayer

func _ready() -> void:
	#leave_button.pressed.connect(_leave_lobby)
	screen_wiper.start_loading.connect(_complete_scene_switch)
	
	screen_wiper.clear_screen_wipe()
	
	lobby_menu_device.leave_lobby.connect(_leave_lobby)
	
	music_player.volume_linear = 0
	fade_audio_in()
	
	
	await get_tree().create_timer(0.2).timeout
	color_rect.hide()
	color_rect.queue_free()


func _leave_lobby() -> void:
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
	music_player.play()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 3, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.play()
