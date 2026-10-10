extends PanelContainer


@export var lobby_name_label:Label
@export var player_count_label:Label
@export var password_protected:RichTextLabel

func _ready() -> void:
	mouse_entered.connect(_change_blue)
	focus_entered.connect(_change_blue)
	
	mouse_exited.connect(_change_white)
	focus_exited.connect(_change_white)

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
