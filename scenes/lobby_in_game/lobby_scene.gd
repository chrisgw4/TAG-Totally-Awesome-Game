extends Node2D


@export var leave_button:Button

@export var screen_wiper:ScreenWiper

@export var color_rect:ColorRect

func _ready() -> void:
	leave_button.pressed.connect(_leave_lobby)
	screen_wiper.start_loading.connect(_complete_scene_switch)
	
	screen_wiper.clear_screen_wipe()
	
	
	await get_tree().create_timer(0.2).timeout
	color_rect.hide()
	color_rect.queue_free()


func _leave_lobby() -> void:
	GDSync.lobby_leave()
	screen_wiper.wipe_screen()
	

func _complete_scene_switch() -> void:
	SceneHolder.change_scene_to.emit(preload("res://scenes/menus/main_menu/main_menu.tscn"), self)
