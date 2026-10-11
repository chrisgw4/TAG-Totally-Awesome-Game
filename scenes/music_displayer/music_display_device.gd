extends CanvasLayer


signal new_song(song_name:String, song_artist:String)

signal hide_device()
signal show_device()

func _ready() -> void:
	new_song.connect(_read_song_data)
	hide_device.connect(_hide)
	show_device.connect(_show)


func _hide() -> void:
	hide()
	$PanelContainer.hide()

func _show() -> void:
	show()
	$PanelContainer.show()

func _read_song_data(song_name:String, song_artist:String) -> void:
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SongName.text = song_name
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/ArtistName.text = song_artist
