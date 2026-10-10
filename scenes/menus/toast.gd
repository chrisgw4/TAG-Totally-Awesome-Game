extends PanelContainer
class_name Toast

@export var label:Label

func _set_text(text:String) -> void:
	label.text = text
