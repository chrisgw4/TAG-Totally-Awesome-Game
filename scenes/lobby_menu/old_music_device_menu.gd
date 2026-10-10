extends CanvasLayer

signal change_scene_to(scene:PackedScene, object)

@export var box_container:BoxContainer

func _ready() -> void:
	change_scene_to.connect(_change_scene)


func _change_scene(scene:PackedScene, object) -> void:
	
	print(scene)
	box_container.add_child(scene.instantiate())
	object.queue_free()
	
