extends Node2D
class_name MainMenu

@export var screen_wiper:ScreenWiper

signal change_scene_to(scene:PackedScene, object:Node)

func _ready() -> void:
	if not GDSync.is_active():
		print("not activated")
	
	screen_wiper.clear_screen_wipe()
	await get_tree().create_timer(0.2).timeout
	$ColorRect.hide()
	$ColorRect.queue_free()


func _swipe_in() -> void:
	pass
