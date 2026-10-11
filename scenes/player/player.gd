extends CharacterBody2D
class_name Player


@export var camera:Camera2D
@export var anim_sprite:SynchronizedAnimatedSprite2D

@export var input_component:InputComponent
@export var movement_component:MovementComponent
@export var jump_component:JumpComponent
@export var gravity_component:GravityComponent

var team:String = ""

var was_in_air = false

func _ready() -> void:
	GDSync.connect_gdsync_owner_changed(self, owner_changed)
	owner_changed(GDSync.get_gdsync_owner(self)) # apply the current owner immediately
	
	anim_sprite.play_synced("idle")
	
	input_component.movement_inputs.connect(movement_component._accelerate_in_direction)
	input_component.grinding_inputs.connect(movement_component._accelerate_in_direction_with_accel)
	input_component.jump_input.connect(jump_component._calculate_jump)
	jump_component.change_gravity_scale.connect(gravity_component._change_gravity_scale)
	jump_component.jump.connect(movement_component.force_velocity_y)
	
	


# This function is called whenever the owner of this node changes
func owner_changed(owner_id : int) -> void:
	var is_owner : bool = GDSync.is_gdsync_owner(self)
	# Only enable the camera if this instance belongs to our local client
	camera.enabled = is_owner


const SPEED := 300.0
const JUMP_VELOCITY := -450.0

func _physics_process(delta: float) -> void:
	if not GDSync.is_gdsync_owner(self):
		return
	if not is_on_floor():
		was_in_air = true
	elif was_in_air and is_on_floor():
		was_in_air = false
		anim_sprite.play_synced("land")
		
		
	
	pass
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	#
	#var dir := Input.get_axis("left", "right")
	#velocity.x = move_toward(velocity.x, dir * SPEED, SPEED * 8 * delta)
	#
	#if is_on_floor() and Input.is_action_just_pressed("jump"):
		#velocity.y = JUMP_VELOCITY
	#
	
	if velocity.x < 0:
		anim_sprite.flip_h = true
	elif velocity.x > 0:
		anim_sprite.flip_h = false
	
	if get_collision_mask_value(3) != true and is_on_floor() == false:
			anim_sprite.play_synced("hurt")
	elif abs(velocity.x) > 0.2 and input_component.grinding == true:
		anim_sprite.play_synced("grind")
	elif abs(velocity.x) > 0.2 and is_on_floor():
		if anim_sprite.animation == "land" :
			await anim_sprite.animation_finished
		if not(Input.is_action_pressed("game_move_right") || Input.is_action_pressed("game_move_left")):
			anim_sprite.play_synced("idle")
		else: #not move key pressed
			anim_sprite.play_synced("run")
	elif is_on_floor() and anim_sprite.animation == "land":
		await anim_sprite.animation_finished
		anim_sprite.play_synced("idle")
	elif is_on_floor():
		anim_sprite.play_synced("idle")
	elif velocity.y < 0 and is_on_floor()==false:
		anim_sprite.play_synced("jump")
	else:
		anim_sprite.play_synced("fall")
	
	
	#move_and_slide()
	
