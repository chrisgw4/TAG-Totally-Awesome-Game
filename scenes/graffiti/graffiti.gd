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
		e_key.play("default")
		ui_element.play_synced(color)


func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent() as Player
	is_tagable(false)
	if parent.input_component.tag_input.is_connected(tag):
		parent.input_component.tag_input.disconnect(tag)
	ui_element.play_synced(color)
