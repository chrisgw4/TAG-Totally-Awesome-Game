extends PanelContainer
class_name LobbyJoinerMenu


@export var join_button:Button
@export var cancel_button:Button
@export var lobby_line_edit:LineEdit
@export var password_line_edit:LineEdit

@export var screen_wiper:ScreenWiper

func _ready() -> void:
	join_button.pressed.connect(_join)
	cancel_button.pressed.connect(_cancel)
	
	screen_wiper.start_loading.connect(_finish_loading_new_scene)



func _cancel() -> void:
	get_parent().get_parent().change_scene_to.emit(load("res://scenes/lobby_menu/lobby_option_selector.tscn"), self)






func _finish_loading_new_scene() -> void:
	#SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_in_game/lobby_scene.tscn"), self)
	pass


func _join() -> void:
	if lobby_line_edit.text.length() < 3:
		return
	
	GDSync.lobby_join(lobby_line_edit.text, password_line_edit.text)
