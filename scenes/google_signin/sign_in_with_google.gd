extends Control
class_name SignInWithGoogleButton

@export var google_button:Button

func _sign_in() -> void:
	pass


var lobby_browser_scene:String = "res://lobby_browser.tscn"

var logged_in:bool = false

signal sign_in_successful()

func _ready():
	print("READY")
	google_button.pressed.connect(_on_google_button_pressed)
	Firebase.Auth.login_succeeded.connect(_on_login_succeeded)
	Firebase.Auth.signup_succeeded.connect(_on_login_succeeded)
	Firebase.Auth.login_failed.connect(_on_login_failed)
	Firebase.Auth.signup_failed.connect(_on_login_failed)
	# Tries to load a saved session and refresh its token
	Firebase.Auth.check_auth_file()
	if OS.has_feature("web"):
		hide()
	else:
		show()


func _sign_in_anonymously() -> void:
	if not logged_in:
		Firebase.Auth.login_anonymous()

func _on_guest_button_pressed():
	Firebase.Auth.login_anonymous()


func _on_google_button_pressed():
	var provider = Firebase.Auth.get_GoogleProvider()
	Firebase.Auth.get_auth_localhost(provider)


func _on_login_succeeded(auth: Dictionary):
	logged_in = true
	Firebase.Auth.save_auth(auth)
	#print("Logged in: ", auth)
	create_document(auth)
	sign_in_successful.emit()


func _on_login_failed(code, message):
	print("Login failed: ", code, " ", message)
	Firebase.Auth.login_anonymous()


func _doc_exists(doc) -> bool:
	return doc is FirestoreDocument and doc.doc_name != ""


func _load_player_data(doc: FirestoreDocument):
	UserGlobalValues.username = doc.get_value("display_name")
	


func create_document(auth: Dictionary) -> void:
	var uid: String = auth.localid
	var is_guest: bool = auth.get("email", "") == ""   # guests have no email
	
	UserGlobalValues.uid = uid
	
	
	var users: FirestoreCollection = Firebase.Firestore.collection("Users")

	var doc = await users.get_doc(uid)
	#print("get_doc result: ", doc)   # check this output the first time

	if _doc_exists(doc):
		#print("Existing user, loading data")
		var now := int(Time.get_unix_time_from_system())
		doc.add_or_update_field("last_active", now)
		
		var updated = await users.update(doc)
		#print("Update result: ", updated)
		
		_load_player_data(doc)
	else:
		print("New user, creating document")
		var now := int(Time.get_unix_time_from_system())
		var new_doc = await users.add(uid, {
			"is_anonymous": is_guest,
			"created_at": now,
			"last_active": now,
			"display_name": auth.get("displayname", "Guest"),
			
			"highest_trick_score":0,
			"jump_count":0,
			"matches_played":0,
			"total_items_used":0,
			"total_tags":0,
			"total_trick_score":0,
			"total_wins":0,
		})
		
		#var task: = await users.update(uid, fields)
		#print("Created: ", new_doc)
		_load_player_data(new_doc)
