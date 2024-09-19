extends Control

@onready var login_screen = get_node("LoginScreen")
@onready var signup_screen = get_node("SignUpScreen")

@onready var login_username_input = get_node("LoginScreen/Username")
@onready var login_password_input = get_node("LoginScreen/Password")
@onready var login_button = get_node("LoginScreen/Login")
@onready var create_account_button = get_node("LoginScreen/CreateAccount")
@onready var login_error_box = get_node("LoginScreen/Error")

@onready var signup_username_input = get_node("SignUpScreen/Username")
@onready var signup_password_input = get_node("SignUpScreen/Password")
@onready var signup_repeat_password_input = get_node("SignUpScreen/RepeatPassword")
@onready var signup_button = get_node("SignUpScreen/SignUp")
@onready var back_button = get_node("SignUpScreen/Back")
@onready var signup_error_box = get_node("SignUpScreen/Error")

func _on_create_account_pressed():
	login_screen.hide()
	signup_screen.show()

func _on_back_pressed():
	signup_screen.hide()
	login_screen.show()

func _on_login_pressed():
	if login_username_input.get_text() == "" or login_password_input.get_text() == "":
		login_error_box.text = "Please provide valid input"
	else:
		login_button.disabled = true
		var username = login_username_input.get_text() 
		var password = login_password_input.get_text()
		print("attempting to login")
		Gateway.ConnectToServer(username, password, false)

func _on_sign_up_pressed():
	if signup_username_input.get_text() == "":
		signup_error_box.text = "Please provide a valid username"
	elif signup_password_input.get_text() == "":
		signup_error_box.text = "Please provide a valid password"
	elif signup_repeat_password_input.get_text() == "":
		signup_error_box.text = "Please repeat your password"
	elif signup_password_input.get_text() != signup_repeat_password_input.get_text():
		signup_error_box.text = "Make sure passwords are the same"
	elif signup_password_input.get_text().length() <= 6:
		signup_error_box.text = "Password must be at least 7 characters"
	else:
		signup_button.disabled = true
		back_button.disabled = true
		var username = signup_username_input.get_text() 
		var password = signup_password_input.get_text()
		print("attempting to create account")
		Gateway.ConnectToServer(username, password, true)
