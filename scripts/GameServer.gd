extends Node3D

const player_scene:PackedScene = preload("res://resource_scenes/player.tscn")
const default_level:PackedScene = preload("res://levels/Hub Level.tscn")

const _PORT = 9999
const _IP = "localhost"
var network = ENetMultiplayerPeer.new()

var token:String


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Game Closing")


func _ready():
	# capture mouse TODO
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	pass


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
func FetchToken():
	print("Server requested token")
	rpc_id(1, "ReturnToken", token)

@rpc
func ReturnToken():
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


@rpc("authority", "call_remote")
func SynchInventories(_player_data:Dictionary):
	print("Synched Inventory")
	#rpc_id(player_id, "SynchInventories", player_data)
