extends CanvasLayer

signal change_scene_to(scene:PackedScene, object)

@export var box_container:FlowContainer
@export var color_rect:ColorRect
@export var screen_wiper:ScreenWiper

func _ready() -> void:
	change_scene_to.connect(_change_scene)
	
	screen_wiper.clear_screen_wipe()
	await get_tree().create_timer(0.2).timeout
	color_rect.hide()
	
	GDSync.lobby_joined.connect(_clear_scene_tree)

func _clear_scene_tree(_lobby_name:String) -> void:
	
	screen_wiper.wipe_screen()
	
	await screen_wiper.start_loading
	queue_free()
	SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_in_game/lobby_scene.tscn"), self)


func _change_scene(scene:PackedScene, object) -> void:
	
	print(scene)
	box_container.add_child(scene.instantiate())
	object.queue_free()
	
