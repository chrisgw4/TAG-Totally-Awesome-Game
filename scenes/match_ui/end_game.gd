extends CanvasLayer




func _ready() -> void:
	#_play_game_end()
	pass
	
	
	
	
	

func _play_game_end() -> void:
	$AnimationPlayer.play("slam")
	
	await $AnimationPlayer.animation_finished
	Engine.time_scale = 1.0
	$AnimationPlayer2.play("fade")
	
	
	var best_player:Dictionary = {}
	
	for client in GDSync.lobby_get_all_clients():
		var data = GDSync.player_get_all_data(client)
		if best_player == {}:
			best_player["score"] = data["score"]
			best_player["username"] = data["Username"]
			best_player["team"] = data["team"]
		elif best_player["score"] < data["score"]:
			best_player["score"] = data["score"]
			best_player["username"] = data["Username"]
			best_player["team"] = data["team"]
	
	$Node2D/Label.text = (best_player['username'] as String).to_lower()
	$AnimationPlayer4.play((best_player['team'] as String).to_lower())
	
	await $AnimationPlayer2.animation_finished
	
	$AnimationPlayer3.play("move_in")
