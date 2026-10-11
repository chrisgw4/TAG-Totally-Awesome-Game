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
	#if GDSync.is_host():
		#graffiti_image.play_synced("nograf")
		#ui_element.play_synced(color)
		#e_key.play("default")
	pass

@onready var blue_spray_paint_particles = $BlueSprayPaint
@onready var red_spray_paint_particles = $RedSprayPaint
@onready var yellow_spray_paint_particles = $YellowSprayPaint
@onready var purple_spray_paint_particles = $PurpleSprayPaint



func _on_area_2d_area_entered(area: Area2D) -> void:
	parent = area.get_parent() as Player
	if not GDSync.is_gdsync_owner(parent):
		e_key.hide()
		return
	
	if parent.team != color:
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


signal tagged_first_time()

func tag(is_pressed: bool):
	if is_pressed and color != parent.team:
		graffiti_image.animation = "tags"
		e_key.hide()
		if not has_been_tagged:
			has_been_tagged = true
			emit_signal("tagged_first_time")
			#GDSync.lobby_set_data("Graffiti_Count", GDSync.lobby_get_data("Graffiti_Count", 0) - 1)
		#if has_been_tagged == false:
			#GDSync.lobby_set_data("Graffiti_Count", GDSync.lobby_get_data("Graffiti_Count", -1) - 1)
			#has_been_tagged = true
		var temp_array = team_tags[parent.team].duplicate()
		if temp_array.has(graffiti_image.frame):
			temp_array.erase(graffiti_image.frame)
		graffiti_image.frame = temp_array.pick_random()
		$SprayStream.play_synced()
		color = parent.team
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
		e_key.play("default")
		ui_element.play_synced(color)
		_spawn_particles(parent.team)

func _spawn_particles(team:String) -> void:
	var particles:GPUParticles2D = null
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
	particles.emitting = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent() as Player
	is_tagable(false)
	if parent.input_component.tag_input.is_connected(tag):
		parent.input_component.tag_input.disconnect(tag)
	ui_element.play_synced(color)
	e_key.hide()
