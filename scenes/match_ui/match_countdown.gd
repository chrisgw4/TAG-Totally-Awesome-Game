extends CanvasLayer
class_name MatchCountdown

@export var countdown_time:int = 3
signal countdown_finished()

func _ready() -> void:
	$CenterContainer/Label.text = str(countdown_time)

func _countdown() -> void:
	for i in range(countdown_time):
		await get_tree().create_timer(1).timeout
		if i == 0:
			$Three.play()
		elif i == 1:
			$Two.play()
		elif i == 2:
			$One.play()
		
		$CenterContainer/Label.text = str(countdown_time - i)
	
	await get_tree().create_timer(1).timeout
	$TAG.play()
	$CenterContainer/Label.text = "tag"
	$AnimationPlayer.play("fade")
	countdown_finished.emit()
