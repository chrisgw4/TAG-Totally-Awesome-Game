extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	#GDSync.lobby_data_changed.connect(_update_white)


func _update_count(new_value) -> void:
	$White.text = str(new_value)

func _update_white(_key, _value) -> void:
	if _key == "Graffiti_Count":
		$White.text = str(_value)
	#$White.text = str(GDSync.lobby_get_data("Graffiti_Count", -1))


func _assign_ownership(player:Player) -> void:
	print("PLAYEr:", player)
	if player.team == "Red":
		GDSync.set_gdsync_owner($Red, player.name.to_int())
	elif player.team == "Yellow":
		GDSync.set_gdsync_owner($Yellow, player.name.to_int())
	elif player.team == "Purple":
		GDSync.set_gdsync_owner($Purple, player.name.to_int())
	elif player.team == "Blue":
		GDSync.set_gdsync_owner($Blue, player.name.to_int())
