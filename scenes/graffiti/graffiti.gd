extends Node2D
@export var ui_element: SynchronizedAnimatedSprite2D
@export var graffiti_image: SynchronizedAnimatedSprite2D
@export var e_key: AnimatedSprite2D
var tagable = false
var parent
var color = "noteam"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	graffiti_image.play_synced("nograf")
	ui_element.play_synced(color)
	e_key.play("default")

var blue_spray_paint_scene:PackedScene = preload("res://scenes/spray_paint_particles/blue_spray_paint.tscn")
var yellow_spray_paint_scene:PackedScene = preload("res://scenes/spray_paint_particles/yellow_spray_paint.tscn")
var red_spray_paint_scene:PackedScene = preload("res://scenes/spray_paint_particles/red_spray_paint.tscn")
var purple_spray_paint_scene:PackedScene = preload("res://scenes/spray_paint_particles/purple_spray_paint.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	parent = area.get_parent() as Player
	if parent.team != color:
		is_tagable(true)
		parent.input_component.tag_input.connect(tag)
		e_key.play("key")
	
func is_tagable(state: bool):
	tagable = state
	
func tag(is_pressed: bool):
	if is_pressed:
		graffiti_image.animation = "tags"
		graffiti_image.frame = randi_range(0, graffiti_image.sprite_frames.get_frame_count("tags"))
		$SprayStream.play_synced()
		color = parent.team
		if color == "Blue":
			var score = parent.get_node("Score").get_node("Blue").text.to_int() + 1
			parent.get_node("Score").get_node("Blue").text = str(score)
		elif color == "Red":
			var score = parent.get_node("Score").get_node("Red").text.to_int() + 1
			parent.get_node("Score").get_node("Red").text = str(score)
		elif color == "Purple":
			var score = parent.get_node("Score").get_node("Purple").text.to_int() + 1
			parent.get_node("Score").get_node("Purple").text = str(score)
		else:
			var score = parent.get_node("Score").get_node("Purple").text.to_int() + 1
			parent.get_node("Score").get_node("Purple").text = str(score)
		e_key.play("default")
		ui_element.play_synced(color)
		_spawn_particles(parent.team)

func _spawn_particles(team:String) -> void:
	var particles:GPUParticles2D = null
	if team == "Blue":
		particles = blue_spray_paint_scene.instantiate()
	elif team == "Yellow":
		particles = yellow_spray_paint_scene.instantiate()
	elif team == "Red":
		particles = red_spray_paint_scene.instantiate()
	elif team == "Purple":
		particles = purple_spray_paint_scene.instantiate()
	
	add_child(particles)
	particles.emitting = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent() as Player
	is_tagable(false)
	if parent.input_component.tag_input.is_connected(tag):
		parent.input_component.tag_input.disconnect(tag)
	ui_element.play_synced(color)
