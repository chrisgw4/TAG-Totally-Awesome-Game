extends CanvasLayer


func _ready() -> void:
	$ScreenWiper.clear_screen_wipe()
	
	await get_tree().create_timer(0.2).timeout
	$CanvasLayer/ColorRect.queue_free()
