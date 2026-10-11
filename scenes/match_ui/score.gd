extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	GDSync.lobby_data_changed.connect(_update_white)


func _update_white(_key, _value) -> void:
	if _key == "Graffiti_Count":
		$White.text = str(_value)
	#$White.text = str(GDSync.lobby_get_data("Graffiti_Count", -1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
