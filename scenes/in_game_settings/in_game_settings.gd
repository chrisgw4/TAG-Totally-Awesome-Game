extends CanvasLayer


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	$AnimationPlayer.play("move_device")


func _hide_music_device() -> void:
	MusicDisplayDevice.hide_device.emit()

func _show_music_device() -> void:
	MusicDisplayDevice.show_device.emit()


func _close() -> void:
	pass


func _change_volume() -> void:
	pass
