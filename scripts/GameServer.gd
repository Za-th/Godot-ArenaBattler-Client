# TODO check in rpc calls if server is still connected

extends Node3D

const player_scene:PackedScene = preload("res://resource_scenes/player.tscn")
const player_controller_scene:PackedScene = preload("res://resource_scenes/PlayerController.tscn")

const _PORT = 9999
const _IP = "localhost"
var network = ENetMultiplayerPeer.new()

var token:String


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Game Closing")


func ConnectToServer():
	network.create_client(_IP, _PORT)
	multiplayer.multiplayer_peer = network
	
	multiplayer.connection_failed.connect(_OnConnectionFailed)
	multiplayer.connected_to_server.connect(_OnConnectionSucceeded)


# TODO fix
func server_disconnect():
	pass
	## remove player nodes
	#for peer_id:int in multiplayer.get_peers():
		#var player:Node3D = get_node(str(peer_id))
		#player.active = false
		#for child in player.get_children():
			#player.remove_child(child)
			#child.queue_free()
	#
	## reset multiplayer peer
	#multiplayer.server_disconnected.disconnect(server_disconnect)
	#multiplayer.multiplayer_peer = null
	#
	#menu.show()


@rpc("authority", "call_remote")
func initialize_controller():
	var player_controller = player_controller_scene.instantiate()
	player_controller.name = str(network.get_unique_id()) + " Controller"
	player_controller.set_multiplayer_authority(get_multiplayer_authority())
	add_child(player_controller)
	
	# set up pathing controller
	PathingController.nav_map = get_tree().root.get_world_3d().navigation_map
	
	# attach mouse click on navmesh to player controller
	for level in get_node("NavigationRegion3D").get_children():
		level.get_node("ClickArea").connect("input_event", player_controller._on_click_area_input_event)


@rpc("authority", "call_remote")
func FetchToken() -> void:
	print("Server requested token")
	rpc_id(1, "ReturnToken", token)

@rpc
func ReturnToken() -> void:
	pass

@rpc("authority", "call_remote")
func ReturnTokenVerificationResults(result:bool) -> void:
	if result == true:
		# remove login screen
		get_node("Menu").queue_free.call_deferred()
		print("Successful token verification")
	else:
		print("Login failed, please try again")
		# reenable login button
		get_node("../Menu/Login").login_button.disabled = false


func _OnConnectionFailed():
	print("Failed to connect to game server")


func _OnConnectionSucceeded():
	print("Succesfully connected to game server")

