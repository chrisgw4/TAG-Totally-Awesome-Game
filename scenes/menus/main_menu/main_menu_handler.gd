extends Node
class_name MainMenuHandler


@export var anim_sprite:AnimatedSprite2D

@export var play_button:TextureButton
@export var setting_button:TextureButton
@export var quit_button:TextureButton


signal play_pressed
signal setting_pressed
signal quit_pressed


func _ready() -> void:
	play_button.mouse_entered.connect(_mouse_hover_play)
	setting_button.mouse_entered.connect(_mouse_hover_setting)
	quit_button.mouse_entered.connect(_mouse_hover_quit)
	
	play_button.mouse_exited.connect(_mouse_exit)
	setting_button.mouse_exited.connect(_mouse_exit)
	quit_button.mouse_exited.connect(_mouse_exit)
	
	play_button.pressed.connect(_play_button_pressed)
	setting_button.pressed.connect(_setting_button_pressed)
	quit_button.pressed.connect(_quit_button_pressed)


func _play_button_pressed() -> void:
	play_pressed.emit()

func _setting_button_pressed() -> void:
	setting_pressed.emit()

func _quit_button_pressed() -> void:
	quit_pressed.emit()


func _mouse_hover_play() -> void:
	anim_sprite.frame = 1

func _mouse_hover_setting() -> void:
	anim_sprite.frame = 2

func _mouse_hover_quit() -> void:
	anim_sprite.frame = 3

func _mouse_exit() -> void:
	anim_sprite.frame = 0
