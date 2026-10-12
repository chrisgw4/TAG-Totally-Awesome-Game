extends CanvasLayer


var is_open:bool = false

@export var leave_button:LobbyMenuOption
@export var close_button:LobbyMenuOption

@export var screen_wiper:ScreenWiper

func _ready() -> void:
	close_button.clicked.connect(close_menu)
	leave_button.clicked.connect(_leave_game)


func _hide_music_device() -> void:
	MusicDisplayDevice.hide_device.emit()

func _show_music_device() -> void:
	MusicDisplayDevice.show_device.emit()


func _leave_game() -> void:
	GDSync.lobby_leave()
	
	var music_player:AudioPlayer = get_parent().get_parent().get_parent().get_node("AudioPlayer") as AudioPlayer
	
	screen_wiper.wipe_screen()
	
	if music_player:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_linear", 0, 1.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.play()
		await screen_wiper.start_loading
		await tween.finished
		music_player.stop()
	else:
		await screen_wiper.start_loading
	
	MusicDisplayDevice.show_device.emit()
	
	SceneHolder.change_scene_to.emit(load("res://scenes/menus/main_menu/main_menu.tscn"), get_parent().get_parent().get_parent())
	
	


func close_menu() -> void:
	is_open = false
	$AnimationPlayer.play("move_device_back")

func open_menu() -> void:
	$AnimationPlayer.play("move_device")
	is_open = true


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("options"):
		if is_open:
			close_menu()
		else:
			open_menu()


func _close() -> void:
	pass


func _change_volume() -> void:
	pass
