extends PanelContainer


@export var create_button:Button
@export var cancel_button:Button
@export var lobby_line_edit:LineEdit
@export var password_line_edit:LineEdit

func _ready() -> void:
	create_button.pressed.connect(_create)
	cancel_button.pressed.connect(_cancel)


func _cancel() -> void:
	get_parent().get_parent().change_scene_to.emit(load("res://scenes/lobby_menu/lobby_option_selector.tscn"), self)

func _create() -> void:
	pass
