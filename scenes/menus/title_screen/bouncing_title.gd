extends Control
class_name BouncingTitle

@export var anim_player:AnimationPlayer

func _bounce() -> void:
	anim_player.play("bounce")
