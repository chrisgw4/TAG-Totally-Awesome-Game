extends CanvasLayer
class_name ToastCanvas

@export_enum("bottom", "bottom_left", "top", "top_left") var location = "bottom_left"

@export var toast:Toast

@export var animation_player:AnimationPlayer

signal toast_hidden()

func _ready() -> void:
	pass

func set_toast_data(text:String) -> void:
	pass

func show_toast(text:String) -> void:
	set_toast_data(text)
	
	if location == "bottom_left":
		animation_player.play("bottom_left_rise")


func _toast_hidden() -> void:
	toast_hidden.emit()

func _hide_toast() -> void:
	if location == "bottom_left":
		animation_player.play_backwards("bottom_left_rise")
		await animation_player.animation_finished
		toast_hidden.emit()
