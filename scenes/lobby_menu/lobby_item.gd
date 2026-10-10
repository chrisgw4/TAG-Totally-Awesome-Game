extends PanelContainer
class_name LobbyItem

@export var lobby_name_label:Label
@export var player_count_label:Label
@export var password_protected:RichTextLabel

@export var button:Button
@export var screen_wiper:ScreenWiper

@export var password_input:LineEdit

signal lobby_selected()

func set_values(lobby_name:String, player_count:int, player_limit:int, has_password:bool) -> void:
	lobby_name_label.text = lobby_name
	player_count_label.text = str(player_count) + "/" + str(player_limit)
	password_protected.visible = has_password
	password_input.visible = has_password

func _ready() -> void:
	button.mouse_entered.connect(_change_blue)
	button.focus_entered.connect(_change_blue)
	
	button.mouse_exited.connect(_change_white)
	button.focus_exited.connect(_change_white)
	
	button.pressed.connect(_join_lobby)
	GDSync.lobby_joined.connect(_lobby_joined)
	screen_wiper.start_loading.connect(_finish_loading_new_scene)

func _join_lobby() -> void:
	if password_protected.visible and password_input.text.length() <= 0:
		return
	
	GDSync.lobby_join(lobby_name_label.text, password_input.text)


func _lobby_joined(lobby_name:String) -> void:
	#screen_wiper.wipe_screen()
	pass

func _finish_loading_new_scene() -> void:
	#SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_in_game/lobby_scene.tscn"), get_parent().get_parent())
	pass


func _change_blue() -> void:
	self_modulate = Color("0094E1")
	lobby_name_label.set("theme_override_colors/font_color", Color.WHITE)
	player_count_label.set("theme_override_colors/font_color", Color.WHITE)
	password_protected.set("theme_override_colors/default_color", Color.WHITE)
	password_protected.text = "[img=16x16]res://assets/LockWhite.png[/img] Password Locked"
	

func _change_white() -> void:
	self_modulate = Color(1,1,1)
	lobby_name_label.set("theme_override_colors/font_color", Color.BLACK)
	player_count_label.set("theme_override_colors/font_color", Color.BLACK)
	password_protected.set("theme_override_colors/default_color", Color.BLACK)
	password_protected.text = "[img=16x16]res://assets/Lock.png[/img] Password Locked"
