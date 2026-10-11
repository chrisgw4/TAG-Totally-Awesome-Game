extends CanvasLayer
class_name MatchCountdown

@export var countdown_time:int = 3
signal countdown_finished()

func _ready() -> void:
	$CenterContainer/Label.text = str(countdown_time)

func _countdown() -> void:
	for i in range(countdown_time):
		await get_tree().create_timer(1).timeout
		$CenterContainer/Label.text = str(countdown_time - i)
	
	await get_tree().create_timer(1).timeout
	$CenterContainer/Label.text = "tag"
	$AnimationPlayer.play("fade")
	countdown_finished.emit()
