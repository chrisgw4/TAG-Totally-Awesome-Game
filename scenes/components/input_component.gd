extends Node
class_name InputComponent


signal movement_inputs(direction:Vector2, delta:float)
signal jump_input(dir:Vector2, is_pressed:bool)
signal dash_inputs(direction:Vector2)
signal drill_inputs(direction:Vector2)
signal super_drill_inputs(direction:Vector2)
signal all_inputs(move_dir:Vector2, jump_dir:Vector2, is_jump_pressed:bool, dash_dir:Vector2, drill_dir:Vector2)

var disabled_inputs:bool = false:
	set(new_val):
		disabled_inputs = new_val
		
		set_physics_process(not disabled_inputs)

# --- NEW: Tracks the player's last horizontal direction ---
# Defaults to right, but will be updated to LEFT or RIGHT when moving.
var last_facing_direction: Vector2 = Vector2.RIGHT
# --------------------------------------------------------

func _disable_inputs() -> void:
	disabled_inputs = true

func _enable_inputs() -> void:
	disabled_inputs = false

# Get inputs during each physics process frame
func _physics_process(delta: float) -> void:
	# Get the direction of the characters input
	var dir:Vector2 = Vector2(Input.get_action_strength("game_move_right")-Input.get_action_strength("game_move_left"), 0).normalized()
	
	# --- NEW: Update the last facing direction ---
	if dir.x != 0:
		last_facing_direction = Vector2(dir.x, 0).normalized()
	# ---------------------------------------------
	
	var is_jump_pressed:bool = false
	var jump_direction:Vector2 = Vector2.ZERO
	var dash_dir:Vector2 = Vector2.ZERO
	var super_drill_dir:Vector2 = Vector2.ZERO
	if Input.is_action_pressed("game_jump"):
		is_jump_pressed = true
		jump_direction = Vector2.UP
	
	
	
	jump_input.emit(jump_direction, is_jump_pressed)
	movement_inputs.emit(dir, delta)
	


func round_to_8_directions(value:float) -> float:
	if value >= 0.25 and value < 0.75:
		value = 0.5
	elif -0.25 < value and value < 0.25:
		value = 0
	elif value <= -0.25 and value > -0.75:
		value = -0.5
	elif value <= -0.75:
		value = -1
	else:
		value = 1
	return value

func turn_vector_into_8_directions(vec:Vector2) -> Vector2:
	var half = sqrt(3)/2
	if vec.x > 0 and vec.y > 0:
		vec.x = half
		vec.y = half
	if vec.x < 0 and vec.y < 0:
		vec.x = -half
		vec.y = -half
	if vec.x > 0 and vec.y < 0:
		vec.x = half
		vec.y = -half
	if vec.x < 0 and vec.y > 0:
		vec.x = -half
		vec.y = half
	
	return vec
