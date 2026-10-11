extends CanvasLayer


func _ready() -> void:
	$AnimationPlayer.play("intro")
	
	await $AnimationPlayer.animation_finished
	$Camera2D.queue_free()
