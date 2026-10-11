extends CanvasLayer


func _ready() -> void:
	$ScreenWiper.clear_screen_wipe()
	
	await get_tree().create_timer(0.2).timeout
	$CanvasLayer/ColorRect.queue_free()
	
	var graffiti_count: int = get_children().filter(func(n): return n is Graffiti).size()
	GDSync.lobby_set_data("Graffiti_Count", graffiti_count)
