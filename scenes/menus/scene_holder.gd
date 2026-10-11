extends CanvasLayer

@export var screen_wiper:ScreenWiper

signal change_scene_to(scene:PackedScene, object)
signal change_scene_for_all(scene:String, object)

signal start_game_for_all()

func _ready() -> void:
	change_scene_to.connect(_change_scene_to)
	change_scene_for_all.connect(_change_scene_for_all)
	GDSync.expose_func(_change_scene_for_all)
	#start_game_for_all.connect(_start_game)


func _change_scene_to(scene:PackedScene, object) -> void:
	if object:
		object.queue_free()
	add_child(scene.instantiate())


#func _start_game() -> void:
	#if not GDSync.is_host():
		#return # only the host triggers it, so clients don't fight
	#var scene = "res://scenes/levels/arena.tscn"
	#GDSync.call_func(_change_scene_for_all, scene) # all other clients
	#_change_scene_for_all(scene)


func _change_scene_for_all(scene:String, object) -> void:
	GDSync.change_scene(scene)
	if object:
		object.queue_free()
	#add_child(load(scene).instantiate())
