extends Node2D
class_name Graffiti
@export var ui_element: SynchronizedAnimatedSprite2D
@export var graffiti_image: SynchronizedAnimatedSprite2D
@export var e_key: AnimatedSprite2D
var tagable = false
var parent
var color = "noteam"

var has_been_tagged:bool = false
	#set(new_value):
		#if has_been_tagged == false and new_value == true:
			#has_been_tagged = new_value
			#GDSync.lobby_set_data("Graffiti_Count", GDSync.lobby_get_data("Graffiti_Count", -1) - 1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GDSync.is_host():
		pass
		#graffiti_image.play_synced("nograf")
		await get_tree().create_timer(0.2).timeout
		ui_element.play_synced(color)
		#e_key.play("default")
	GDSync.player_set_data("score", 0)
	GDSync.expose_func(_roll_graffiti_frame)
	GDSync.expose_func(_update_clients_player_data)
	GDSync.expose_func(_update_particle_process_materials)
	pass

@onready var red_spray_paint_particles = $RedSprayPaint

@onready var red_spray_tres:ParticleProcessMaterial = preload("res://scenes/spray_paint_particles/red_spray_paint_particles.tres")
@onready var blue_spray_tres:ParticleProcessMaterial = preload("res://scenes/spray_paint_particles/blue_spray_paint_particles.tres")
@onready var yellow_spray_tres:ParticleProcessMaterial = preload("res://scenes/spray_paint_particles/yellow_spray_paint_particles.tres")
@onready var purple_spray_tres:ParticleProcessMaterial = preload("res://scenes/spray_paint_particles/purple_spray_paint_particles.tres")

# Host will call this function on the client's game
# This will update their player data since score is now handled in host's game
func _update_clients_player_data(new_score:int, frame:int) -> void:
	print("UPDAING SCORE TO: ", new_score)
	GDSync.player_set_data("score", new_score)
	#graffiti_image.visible = true
	#graffiti_image.set_frame_and_progress_synced(frame, 0)


func _roll_graffiti_frame(team:String, client_id:int) -> void:
	print("TEAM: ", team)
	print("CLIENT ID: ", client_id)
	
	if not has_been_tagged:
		has_been_tagged = true
	
	var temp_array = team_tags[team].duplicate()
	if temp_array.has(graffiti_image.frame):
		temp_array.erase(graffiti_image.frame)
	
	var frame:int = temp_array.pick_random()
	graffiti_image.visible = true
	graffiti_image.set_frame_and_progress_synced(frame, 0)
	#graffiti_image.frame = temp_array.pick_random()
	color = team
	ui_element.play_synced(color)
	
	# Update Scores
	if color == "Blue":
		var score = GDSync.player_get_data(client_id, 'score', 0) + 1
		get_parent().get_node("Score").get_node("Blue").text = str(score)
		GDSync.call_func_on(client_id, _update_clients_player_data, score, frame)
		
	elif color == "Red":
		var score = GDSync.player_get_data(client_id, 'score', 0) + 1
		get_parent().get_node("Score").get_node("Red").text = str(score)
		GDSync.call_func_on(client_id, _update_clients_player_data, score, frame)
	elif color == "Purple":
		var score = GDSync.player_get_data(client_id, 'score', 0) + 1
		get_parent().get_node("Score").get_node("Purple").text = str(score)
		GDSync.call_func_on(client_id, _update_clients_player_data, score, frame)
	else:
		var score = GDSync.player_get_data(client_id, 'score', 0) + 1
		get_parent().get_node("Score").get_node("Yellow").text = str(score)
		GDSync.call_func_on(client_id, _update_clients_player_data, score, frame)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var temp_parent = area.get_parent() as Player
	
	if GDSync.is_gdsync_owner(temp_parent):
		parent = temp_parent
	else:
		return
	
	if parent.team != color and GDSync.is_gdsync_owner(parent):
		is_tagable(true)
		parent.input_component.tag_input.connect(tag)
		e_key.play("key")
		e_key.show()
	
func is_tagable(state: bool):
	tagable = state


var team_tags:Dictionary[String, Array] = {
	"Blue":[0,1,2,3,4,5,6,7],
	"Red":[0,1,2,3,4,5,8,9],
	"Yellow":[0,1,2,3,4,5,10,11],
	"Purple":[0,1,2,3,4,5,12,13],
	}



func tag(is_pressed: bool):
	if is_pressed and color != parent.team and e_key.visible:
		e_key.hide()
		
		if not GDSync.is_host():
			GDSync.call_func_on(GDSync.get_host(), _roll_graffiti_frame, parent.team, GDSync.get_client_id())
		else:
			_roll_graffiti_frame(parent.team, GDSync.get_client_id())
		color = parent.team
		$SprayStream.play_synced()
		
		if GDSync.is_gdsync_owner(parent):
			e_key.play("default")
		#ui_element.play_synced(color)
		_spawn_particles(parent.team)


func _update_particle_process_materials(team:String) -> void:
	var particles:GPUParticles2D = red_spray_paint_particles
	
	if team == "Blue":
		particles.process_material = blue_spray_tres
	elif team == "Yellow":
		particles.process_material = yellow_spray_tres
	elif team == "Purple":
		particles.process_material = purple_spray_tres
	elif team == "Red":
		particles.process_material = red_spray_tres
	
	particles.restart()

func _spawn_particles(team:String) -> void:
	var particles:GPUParticles2D = red_spray_paint_particles
	
	GDSync.call_func_all(_update_particle_process_materials, team)
	
	
	
	#if team == "Blue":
		#particles = blue_spray_paint_particles
		#particles.restart()
		##particles = blue_spray_paint_scene.instantiate()
	#elif team == "Yellow":
		#particles = yellow_spray_paint_particles
		#particles.restart()
		##particles = yellow_spray_paint_scene.instantiate()
	#elif team == "Red":
		#particles = red_spray_paint_particles
		#particles.restart_synced()
		##particles = red_spray_paint_scene.instantiate()
	#elif team == "Purple":
		#particles = purple_spray_paint_particles
		#particles.restart()
		##particles = purple_spray_paint_scene.instantiate()
	#
	##add_child(particles)
	##if particles.emitting:
	#particles.restart()
	#particles.emitting = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent() as Player
	if GDSync.is_gdsync_owner(parent):
		is_tagable(false)
		if parent.input_component.tag_input.is_connected(tag):
			parent.input_component.tag_input.disconnect(tag)
		
		e_key.hide()
