extends Node

var username:String = "Guest":
	set(new_username):
		username = new_username
		_update_database_with_username()
		
		if GDSync.is_active():
			GDSync.player_set_username(username)
			


var uid:String = ""

func _doc_exists(doc) -> bool:
	return doc is FirestoreDocument and doc.doc_name != ""

func _update_database_with_username() -> void:
	var users: FirestoreCollection = Firebase.Firestore.collection("Users")

	var doc = await users.get_doc(uid)
	
	if _doc_exists(doc):
		doc.add_or_update_field("display_name", username)
		
		var _updated = await users.update(doc)
