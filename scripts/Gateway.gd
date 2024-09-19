extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
const _IP = "localhost"
const PORT = 1910

var username:String
var password:String
var create_account:bool


func _ready():
	pass


func _process(_delta):
	if multiplayer == null:
		return
	if not multiplayer.has_multiplayer_peer():
		return
	multiplayer.poll()


func ConnectToServer(_username:String, _password:String, _create_account:bool):
	network = ENetMultiplayerPeer.new()
	gateway_api = SceneMultiplayer.new()
	
	username = _username
	password = _password
	create_account = _create_account
	
	network.create_client(_IP, PORT)
	get_tree().set_multiplayer(gateway_api, self.get_path())
	multiplayer.multiplayer_peer = network
	
	multiplayer.connection_failed.connect(_OnConnectionFailed)
	multiplayer.connected_to_server.connect(_OnConnectionSucceeded)


func _OnConnectionFailed():
	print("Failed to connect to login server")
	if create_account:
		$"../Main/Menu".signup_button.disabled = false
		$"../Main/Menu".back_button.disabled = false
	else:
		$"../Main/Menu".login_button.disabled = false


func _OnConnectionSucceeded():
	print("Succesfully connected to login server")
	if create_account:
		RequestSignUp()
	else:
		RequestLogin()

# Login functions

func RequestLogin():
	print("Connecting to a gateway to request login")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""


@rpc("authority", "call_remote")
func ReturnLoginRequest(result, token):
	print("results received")
	if result == true:
		# if multiple game servers need to get ip
		get_node("../Main").token = token
		get_node("../Main").ConnectToServer()
		
		# remove login screen
		get_node("../Main/Menu").hide()
	else:
		print("Please provide correct username and password")
		$"../Main/Menu".login_button.disabled = false
	multiplayer.connection_failed.disconnect(_OnConnectionFailed)
	multiplayer.connected_to_server.disconnect(_OnConnectionSucceeded)


@rpc("authority", "call_remote")
func LoginRequest(_u, _p):
	pass

# Sign Up functions

@rpc("authority", "call_remote")
func RequestSignUp():
	print("Requesting new account")
	rpc_id(1, "RequestSignUp", username, password)
	username = ""
	password = ""

@rpc("authority", "call_remote")
func ReturnCreateAccountRequest(valid_request:bool, message:int):
	print("Received New Acct results: " + str(valid_request))
	if valid_request and message == 3:
		print("Successfully created account")
		get_node("../Main/Menu")._on_back_pressed()
	else:
		if message == 2:
			print("Username in use")
		elif message == 1:
			print("Something went wrong, " + str(valid_request) + " " + str(message))
		get_node("../Main/Menu").signup_button.disabled = false
		get_node("../Main/Menu").back_button.disabled = false
	multiplayer.connection_failed.disconnect(_OnConnectionFailed)
	multiplayer.connected_to_server.disconnect(_OnConnectionSucceeded)
