extends CanvasLayer


signal new_song(song_name:String, song_artist:String)

func _ready() -> void:
	new_song.connect(_read_song_data)
	
	

func _read_song_data(song_name:String, song_artist:String) -> void:
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/SongName.text = song_name
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/ArtistName.text = song_artist
