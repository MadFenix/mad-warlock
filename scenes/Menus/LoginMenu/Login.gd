extends Control

var registro_scene;
var mecenas_scene;
var profile_scene;
var input_email;
var input_password;
var lbl_response_message;
var http_request;

signal hideLoginMenu;
signal showRegisterMenu;

# Called when the node enters the scene tree for the first time.
func _ready():
	input_email = $CntJuego/CntEmailBox/LEEmail;
	input_password = $CntJuego/CntPasswordBox/LEPassword;
	http_request = $CntJuego/CntBtnLogin/HTTPRequestLogin;
	lbl_response_message = $CntJuego/CntResponseMessage/LblResponseMessage;
	http_request.request_completed.connect(_on_request_login_completed);
	pass # Replace with function body.

func _on_request_login_completed(result, response_code, headers, body):
	if (response_code != 200):
		lbl_response_message.text = "Error al entrar.";
		return;
	var json = JSON.parse_string(body.get_string_from_utf8());
	Autoload.setCredentialToken(json.token);
	Autoload.loadProfile(%HTTPRequestProfileLogin);
	hideLoginMenu.emit();

func _on_btn_login_pressed():
	var data_to_send = {
		"email": input_email.text,
		"password": input_password.text,
		"device_name": OS.get_name(),
	};
	var json = JSON.stringify(data_to_send);
	var headers = [
		"Content-Type: application/json",
		"Access-Control-Allow-Origin: *"
	];
	var url = Autoload.apiBase + "/login";
	http_request.request(url, headers, HTTPClient.METHOD_POST, json);

func _on_btn_back_pressed():
	hideLoginMenu.emit();

func _on_btn_registro_pressed():
	showRegisterMenu.emit();

func _on_btn_forgot_pressed():
	OS.shell_open("https://madfenix.com/recordar-password");
