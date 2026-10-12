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
		ui_element.play_synced(color)
		#e_key.play("default")
	GDSync.expose_func(_roll_graffiti_frame)
	pass

@onready var blue_spray_paint_particles = $BlueSprayPaint
@onready var red_spray_paint_particles = $RedSprayPaint
@onready var yellow_spray_paint_particles = $YellowSprayPaint
@onready var purple_spray_paint_particles = $PurpleSprayPaint


func _roll_graffiti_frame(team:String) -> void:
	print("TEAM: ", team)
	
	if not has_been_tagged:
		has_been_tagged = true
	
	var temp_array = team_tags[team].duplicate()
	if temp_array.has(graffiti_image.frame):
		temp_array.erase(graffiti_image.frame)
	graffiti_image.animation = "tags"
	graffiti_image.set_frame_and_progress_synced(temp_array.pick_random(), 0)
	#graffiti_image.frame = temp_array.pick_random()
	color = team
	ui_element.play_synced(color)


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
			GDSync.call_func_on(GDSync.get_host(), _roll_graffiti_frame, parent.team)
		else:
			_roll_graffiti_frame(parent.team)
		color = parent.team
		$SprayStream.play_synced()
		if color == "Blue":
			var score = GDSync.player_get_data(GDSync.get_client_id(), 'score', 0) + 1
			get_parent().get_node("Score").get_node("Blue").text = str(score)
			GDSync.player_set_data("score", score)
		elif color == "Red":
			var score = GDSync.player_get_data(GDSync.get_client_id(), 'score', 0) + 1
			get_parent().get_node("Score").get_node("Red").text = str(score)
			GDSync.player_set_data("score", score)
		elif color == "Purple":
			var score = GDSync.player_get_data(GDSync.get_client_id(), 'score', 0) + 1
			get_parent().get_node("Score").get_node("Purple").text = str(score)
			GDSync.player_set_data("score", score)
		else:
			var score = GDSync.player_get_data(GDSync.get_client_id(), 'score', 0) + 1
			get_parent().get_node("Score").get_node("Yellow").text = str(score)
			GDSync.player_set_data("score", score)
		print("Score: ",GDSync.player_get_data(GDSync.get_client_id(), 'score', 0))
		#GDSync.lobby_get_all_clients()
		if GDSync.is_gdsync_owner(parent):
			e_key.play("default")
		#ui_element.play_synced(color)
		_spawn_particles(parent.team)

func _spawn_particles(team:String) -> void:
	var particles:SynchronizedGPUParticles2D = null
	if team == "Blue":
		particles = blue_spray_paint_particles
		#particles = blue_spray_paint_scene.instantiate()
	elif team == "Yellow":
		particles = yellow_spray_paint_particles
		#particles = yellow_spray_paint_scene.instantiate()
	elif team == "Red":
		particles = red_spray_paint_particles
		#particles = red_spray_paint_scene.instantiate()
	elif team == "Purple":
		particles = purple_spray_paint_particles
		#particles = purple_spray_paint_scene.instantiate()
	
	#add_child(particles)
	#if particles.emitting:
	particles.restart_synced()
	#particles.emitting = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent() as Player
	if GDSync.is_gdsync_owner(parent):
		is_tagable(false)
		if parent.input_component.tag_input.is_connected(tag):
			parent.input_component.tag_input.disconnect(tag)
		
		e_key.hide()
