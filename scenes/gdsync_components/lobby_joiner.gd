extends Node

func _ready() -> void:
	GDSync.lobby_joined.connect(_joined_lobby)


func _joined_lobby(lobby_name:String) -> void:
	pass
	#SceneHolder.change_scene_to.emit(preload("res://scenes/lobby_in_game/lobby_scene.tscn"), null)
	#SceneHolder.get_child(0).queue_free()
