extends CanvasLayer
class_name ToastCanvas

@export_enum("bottom", "bottom_left", "top", "top_left") var location = "bottom_left"

@export var toast:Toast

@export var animation_player:AnimationPlayer

@export var timer:Timer

signal toast_hidden()

func _ready() -> void:
	timer.timeout.connect(_hide_toast)

func set_toast_data(text:String) -> void:
	toast._set_text(text)

func show_toast_for_time(text:String, time:float=1) -> void:
	set_toast_data(text)
	
	timer.start(time)
	
	if location == "bottom_left":
		animation_player.play("bottom_left_rise")

func show_toast(text:String) -> void:
	set_toast_data(text)
	timer.stop()
	
	if location == "bottom_left":
		animation_player.play("bottom_left_rise")


func _toast_hidden() -> void:
	toast_hidden.emit()

func _hide_toast() -> void:
	if location == "bottom_left":
		animation_player.play_backwards("bottom_left_rise")
		await animation_player.animation_finished
		toast_hidden.emit()
