extends CanvasLayer

@export var screen_wiper:ScreenWiper
@export var music_player:AudioPlayer

@export var back_button:TextureButton

var music_volume = 50;
var effects_volume = 50;

var music_index = AudioServer.get_bus_index("Music")
var effects_index = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	music_player._replay_song()
	screen_wiper.clear_screen_wipe()
	
	var tween = create_tween()
	music_player.volume_linear = 0
	tween.tween_property(music_player, "volume_linear", 1, 1)
	
	await get_tree().create_timer(0.2).timeout
	$CanvasLayer.queue_free()
	
	
	
	$MusicSlider.value = AudioServer.get_bus_volume_linear(music_index)
	$EffectsSlider.value = AudioServer.get_bus_volume_linear(effects_index)
	
	back_button.mouse_entered.connect(_hover_back_button)
	back_button.mouse_exited.connect(_unhover_back_button)
	back_button.pressed.connect(_swap_scene_to_main_menu)


func _swap_scene_to_main_menu() -> void:
	screen_wiper.wipe_screen()
	
	var tween = create_tween()
	tween.tween_property(music_player, "volume_linear", 0, 1)
	tween.play()
	
	#await screen_wiper.start_loading
	await tween.finished
	
	SceneHolder.change_scene_to.emit(load("res://scenes/menus/main_menu/main_menu.tscn"), self)


func _hover_back_button() -> void:
	back_button.scale = Vector2(0.75, 0.75)

func _unhover_back_button() -> void:
	back_button.scale = Vector2(0.7, 0.7)



func _on_music_slider_value_changed(value: float) -> void:
	music_volume = value
	AudioServer.set_bus_volume_db(music_index, linear_to_db(music_volume)) #1.0 -> 0db, 0.0 -> -inf db


func _on_effects_slider_value_changed(value: float) -> void:
	effects_volume = value
	AudioServer.set_bus_volume_db(effects_index, linear_to_db(effects_volume)) #1.0 -> 0db, 0.0 -> -inf db


func _on_text_edit_text_submitted(new_text: String) -> void:
	UserGlobalValues.username = $TextEdit.text
