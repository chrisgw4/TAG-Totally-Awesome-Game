extends Node2D
@export var ui_element: AnimatedSprite2D
var tagable = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui_element.play("arrow")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	var parent = area.get_parent() as player
	is_tagable(true)
	parent.input_component.tag_input.connect(tag)
	ui_element.play("key")
	
func is_tagable(state: bool):
	tagable = state
	
func tag(is_pressed: bool):
	if is_pressed:
		print("Ello Govna")
	



func _on_area_2d_area_exited(area: Area2D) -> void:
	var parent = area.get_parent() as player
	is_tagable(false)
	parent.input_component.tag_input.disconnect(tag)
	ui_element.play("arrow")
