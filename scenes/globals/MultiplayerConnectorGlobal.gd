extends Node


signal gdsync_connection_success()
signal gdsync_connection_failed(error:int)

signal connecting_to_gdsync

func _ready() -> void:
	GDSync.connected.connect(_connection_success)
	GDSync.connection_failed.connect(_connection_failed)

func check_connected_to_gdsync() -> void:
	if not GDSync.is_active():
		print("GDSync not active")
		connecting_to_gdsync.emit()
		_connect_to_gdsync()


func _connect_to_gdsync() -> void:
	GDSync.start_multiplayer()

func _connection_success() -> void:
	print("Connected Successfully")
	gdsync_connection_success.emit()


func _connection_failed(error:int) -> void:
	print("Connected Not Successfully")
	gdsync_connection_failed.emit(error)
	match(error):
		ENUMS.CONNECTION_FAILED.INVALID_PUBLIC_KEY:
			push_error("The public or private key you entered were invalid.")
		ENUMS.CONNECTION_FAILED.TIMEOUT:
			push_error("Unable to connect, please check your internet connection.")
			
