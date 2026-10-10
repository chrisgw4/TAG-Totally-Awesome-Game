extends CanvasLayer
class_name ScreenWiper


signal start_loading

func _start_load() -> void:
	start_loading.emit()


func wipe_screen() -> void:
	$AnimationPlayer.play("WipeRightToLeft")

func clear_screen_wipe() -> void:
	$AnimationPlayer.play("ClearWipeRightToLeft")
