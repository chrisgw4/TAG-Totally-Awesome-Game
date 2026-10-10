extends Panel
class_name LobbyMenuOption

@export var label:Label
@export var arrow:Label

@export var label_text:String

@export var button:Button

signal clicked()

func _ready() -> void:
	label.text = label_text
	
	button.focus_entered.connect(_change_blue)
	button.mouse_entered.connect(_change_blue)
	
	button.mouse_exited.connect(_change_white)
	button.focus_exited.connect(_change_white)
	
	button.pressed.connect(_clicked)

func _clicked() -> void:
	clicked.emit()

func _change_blue() -> void:
	self_modulate = Color("0094E1")
	label.set("theme_override_colors/font_color", Color.WHITE)
	arrow.show()
	#label.add_theme_color_override("font_color", Color.WHITE)

func _change_white() -> void:
	self_modulate = Color(1,1,1)
	#label.add_theme_color_override("font_color", Color(0, 0, 0))
	label.set("theme_override_colors/font_color", Color.BLACK)
	arrow.hide()
