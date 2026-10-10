extends Node2D

@export var start_button:TextureButton
@export var multiplayer_connector:MultiplayerConnector
@export var toast_canvas:ToastCanvas
@export var screen_wiper:ScreenWiper

@export var main_menu_scene:PackedScene = preload("res://scenes/menus/main_menu/main_menu.tscn")

signal change_scene_to(scene:PackedScene, object:Node)

func _ready() -> void:
	#start_button.pressed.connect(_start_sync)
	start_button.pressed.connect(_fade_to_change_scene)
	GDSync.connected.connect(_change_scene_to_main_menu)
	pass


func _fade_to_change_scene() -> void:
	screen_wiper.wipe_screen()
	#screen_wiper.start_loading.connect(_change_scene_to_main_menu)
	screen_wiper.start_loading.connect(_start_sync)


func _change_scene_to_main_menu() -> void:
	print("here")
	await toast_canvas.toast_hidden
	SceneHolder.change_scene_to.emit(main_menu_scene, self)
	#get_tree().current_scene.add_child(main_menu_scene.instantiate())


func _start_sync() -> void:
	if not multiplayer_connector:
		return
	
	multiplayer_connector._connect_to_gdsync()
	toast_canvas.show_toast("Connecting to Multiplayer...")
	multiplayer_connector.gdsync_connection_success.connect(toast_canvas._hide_toast)
