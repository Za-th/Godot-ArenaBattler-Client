extends Node

var network = ENetMultiplayerPeer.new()
var gateway_api = SceneMultiplayer.new()
const _IP = "localhost"
const PORT = 1910

var username:String
var password:String
var create_account:bool

@onready var player_menu = get_node("../Main/Menu")

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
	if create_account:
		player_menu.signup_button.disabled = false
		player_menu.back_button.disabled = false
		player_menu.signup_error_box.text = "Failed to connect to login server"
	else:
		player_menu.login_button.disabled = false


func _OnConnectionSucceeded():
	print("Succesfully connected to login server")
	if create_account:
		RequestSignUp()
	else:
		LoginRequest()

# Login functions

@rpc("authority", "call_remote")
func LoginRequest():
	print("Connecting to a gateway to request login")
	rpc_id(1, "LoginRequest", username, password)
	username = ""
	password = ""


@rpc("authority", "call_remote")
func ReturnLoginRequest(result, token):
	if result == true:
		# if multiple game servers need to get ip
		get_node("../Main").token = token
		get_node("../Main").ConnectToServer()
	else:
		player_menu.login_error_box.text = "Please provide correct username and password"
		player_menu.login_button.disabled = false
	multiplayer.connection_failed.disconnect(_OnConnectionFailed)
	multiplayer.connected_to_server.disconnect(_OnConnectionSucceeded)


# Sign Up functions

@rpc("authority", "call_remote")
func RequestSignUp():
	print("Requesting new account")
	rpc_id(1, "RequestSignUp", username, password)
	username = ""
	password = ""

@rpc("authority", "call_remote")
func ReturnCreateAccountRequest(valid_request:bool, message:int):
	if valid_request and message == 3:
		player_menu.signup_error_box.text = "Successfully created account"
		player_menu._on_back_pressed()
		player_menu.signup_button.disabled = false
		player_menu.back_button.disabled = false
	else:
		if message == 2:
			player_menu.signup_error_box.text = "Username in use"
		elif message == 1:
			player_menu.signup_error_box.text = "Something went wrong, " + str(valid_request) + " " + str(message)
		player_menu.signup_button.disabled = false
		player_menu.back_button.disabled = false
	multiplayer.connection_failed.disconnect(_OnConnectionFailed)
	multiplayer.connected_to_server.disconnect(_OnConnectionSucceeded)
