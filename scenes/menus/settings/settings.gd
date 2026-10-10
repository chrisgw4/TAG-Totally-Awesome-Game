extends CanvasLayer

var music_volume = 50;
var effects_volume = 50;

var music_index = AudioServer.get_bus_index("Music")
var effects_index = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_music_slider_value_changed(value: float) -> void:
	music_volume = $MusicSlider.value
	AudioServer.set_bus_volume_db(music_index, linear_to_db(music_volume)) #1.0 -> 0db, 0.0 -> -inf db


func _on_effects_slider_value_changed(value: float) -> void:
	effects_volume = $EffectsSlider.value
	AudioServer.set_bus_volume_db(music_index, linear_to_db(effects_volume)) #1.0 -> 0db, 0.0 -> -inf db


func _on_text_edit_text_submitted(new_text: String) -> void:
	UserGlobalValues.username = $TextEdit.text
	print(UserGlobalValues.username)
	emit_signal("username_inserted")
