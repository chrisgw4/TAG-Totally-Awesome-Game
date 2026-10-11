extends Panel
class_name MenuOption_Audio


@export var label:Label


@export var left_button:Button
@export var right_button:Button

@export var label_text:String:
	set(new_text):
		label_text = new_text


var current_volume:int = 100:
	set(new_volume):
		current_volume = new_volume
		$Label3.text = str(current_volume) + "%"



func _ready() -> void:
	label.text = label_text
	
	left_button.pressed.connect(_decrease)
	right_button.pressed.connect(_increase)
	
	var bus_index = AudioServer.get_bus_index(label_text)
	current_volume = AudioServer.get_bus_volume_linear(bus_index) * 100


func _decrease() -> void:
	var bus_index = AudioServer.get_bus_index(label_text)
	var volume = clampf(AudioServer.get_bus_volume_linear(bus_index) - 0.01, 0, 1.5)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	current_volume = volume * 100

func _increase() -> void:
	var bus_index = AudioServer.get_bus_index(label_text)
	var volume = clampf(AudioServer.get_bus_volume_linear(bus_index) + 0.01, 0, 1.5)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume))
	current_volume = volume * 100

func _change_blue() -> void:
	self_modulate = Color("0094E1")
	label.set("theme_override_colors/font_color", Color.WHITE)
	#label.add_theme_color_override("font_color", Color.WHITE)

func _change_white() -> void:
	self_modulate = Color(1,1,1)
	#label.add_theme_color_override("font_color", Color(0, 0, 0))
	label.set("theme_override_colors/font_color", Color.BLACK)
