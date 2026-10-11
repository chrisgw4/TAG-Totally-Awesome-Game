extends AudioStreamPlayer
class_name AudioPlayer

@export var song_streams:Array[AudioStream] = []
@export var song_names:Array[String] = []
@export var song_artists:Array[String] = []


var unplayed_songs = []
var current_song = null
var current_artist = ""
var current_song_name = ""

func _ready() -> void:
	finished.connect(_replay_song)

func _replay_song() -> void:
	if unplayed_songs.size() == 0:
		unplayed_songs = song_streams.duplicate()
	
	current_song = unplayed_songs.pick_random()
	unplayed_songs.erase(current_song)
	stream = current_song
	
	current_artist = song_artists[song_streams.find(current_song)]
	current_song_name = song_names[song_streams.find(current_song)]
	
	MusicDisplayDevice.new_song.emit(current_artist, current_song_name)
	
	play()
	
