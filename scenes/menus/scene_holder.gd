extends CanvasLayer

signal change_scene_to(scene:PackedScene, object)

func _ready() -> void:
	change_scene_to.connect(_change_scene_to)

func _change_scene_to(scene:PackedScene, object) -> void:
	object.queue_free()
	add_child(scene.instantiate())
