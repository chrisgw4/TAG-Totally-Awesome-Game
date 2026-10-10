extends PanelContainer


@export var create_button:Button
@export var cancel_button:Button
@export var lobby_line_edit:LineEdit
@export var password_line_edit:LineEdit

@export var screen_wiper:ScreenWiper

func _ready() -> void:
	create_button.pressed.connect(_create)
	cancel_button.pressed.connect(_cancel)
	
	GDSync.lobby_created.connect(_join_created_lobby)
	GDSync.lobby_joined.connect(_created_lobby_joined)
	screen_wiper.start_loading.connect(_finish_loading_new_scene)



func _cancel() -> void:
	get_parent().get_parent().change_scene_to.emit(load("res://scenes/lobby_menu/lobby_option_selector.tscn"), self)


func _join_created_lobby(lobby_name:String) -> void:
	GDSync.lobby_join(lobby_line_edit.text, password_line_edit.text)


func _created_lobby_joined(lobby_name:String) -> void:
	#screen_wiper.wipe_screen()
	pass


func _finish_loading_new_scene() -> void:
	#SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_in_game/lobby_scene.tscn"), self)
	pass


func _create() -> void:
	if lobby_line_edit.text.length() <= 3:
		return
	
	GDSync.lobby_create(lobby_line_edit.text, password_line_edit.text, true, 2)
