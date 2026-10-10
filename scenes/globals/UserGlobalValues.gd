extends Node

var username:String = "Guest":
	set(new_username):
		username = new_username
		
		if GDSync.is_active():
			GDSync.player_set_username(username)


var uid:String = ""
