extends CanvasLayer

@export var match_countdown:MatchCountdown
@export var player_spawner:Node2D
var count:int = 0
var stop:bool = false

func _ready() -> void:
	$ScreenWiper.clear_screen_wipe()
	
	$AnimationPlayer.play("move_camera")
	
	if GDSync.is_host():
		var graffiti_count: int = get_children().filter(func(n): return n is Graffiti).size()
		GDSync.lobby_set_data("Graffiti_Count", graffiti_count)
		count = graffiti_count
		$Timer.timeout.connect(_recount_graffiti)
		$Timer.start()
		
		#for n in get_children():
			#if n is Graffiti:
				#n.tagged_first_time.connect(_update_count)
	
	match_countdown.countdown_finished.connect(_enable_player_movements)
	
	_start_countdown()
	
	await get_tree().create_timer(0.2).timeout
	$CanvasLayer/ColorRect.queue_free()
	
	$AudioPlayer._replay_song()


func _recount_graffiti() -> void:
	count = 0
	for n in get_children():
		if n is Graffiti:
			if not n.has_been_tagged:
				count += 1
	
	$Score._update_count(count)
	
	if count == 0 and not stop:
		stop = true
		$SynchronizedAnimationPlayer.play_synced("sync_win")
		#print("GAME")
		#_disable_player_movements()
		#$AudioPlayer.pitch_scale = 0.2
		#Engine.time_scale = 0.2
		#var tween = create_tween()
		#tween.tween_property($AudioPlayer as AudioPlayer, "volume_db", -100, 1)
		#tween.play()
		#
		##await get_tree().create_timer(0.1).timeout
		#$EndGame._play_game_end()
	else:
		$Timer.start()


func _win() -> void:
	print("GAME")
	_disable_player_movements()
	$AudioPlayer.pitch_scale = 0.2
	Engine.time_scale = 0.2
	var tween = create_tween()
	tween.tween_property($AudioPlayer as AudioPlayer, "volume_db", -100, 1)
	tween.play()
	
	#await get_tree().create_timer(0.1).timeout
	$EndGame._play_game_end()

#func _update_count() -> void:
	#count -= clamp(1, 0, 100)
	#GDSync.lobby_set_data("Graffiti_Count", count)


func _enable_player_movements() -> void:
	var players : Array[Player] = []
	for n in $PlayerSpawner.get_children():
		if n is Player:
			n.input_component._enable_inputs()
			#n.movement_component._enable_movement()

func _disable_player_movements() -> void:
	for n in $PlayerSpawner.get_children():
		if n is Player:
			print("Player", n)
			n.input_component._disable_inputs()
			#n.movement_component._disable_movement()


func _start_countdown() -> void:
	_disable_player_movements()
	
	match_countdown._countdown()
