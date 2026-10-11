extends CanvasLayer

@export var match_countdown:MatchCountdown
@export var player_spawner:Node2D

func _ready() -> void:
	$ScreenWiper.clear_screen_wipe()
	
	$AnimationPlayer.play("move_camera")
	
	var graffiti_count: int = get_children().filter(func(n): return n is Graffiti).size()
	GDSync.lobby_set_data("Graffiti_Count", graffiti_count)
	
	match_countdown.countdown_finished.connect(_enable_player_movements)
	
	_start_countdown()
	
	await get_tree().create_timer(0.2).timeout
	$CanvasLayer/ColorRect.queue_free()
	
	$AudioPlayer._replay_song()
	
	


func _enable_player_movements() -> void:
	var players : Array[Player] = []
	for n in $PlayerSpawner.get_children():
		if n is Player:
			n.input_component._enable_inputs()
			#n.movement_component._enable_movement()
	


func _start_countdown() -> void:
	for n in $PlayerSpawner.get_children():
		if n is Player:
			print("Player", n)
			n.input_component._disable_inputs()
			#n.movement_component._disable_movement()
			
	match_countdown._countdown()
