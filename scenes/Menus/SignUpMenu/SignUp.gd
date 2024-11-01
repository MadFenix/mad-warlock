extends Control

var login_scene;
var opciones_scene;
var input_username;
var input_email;
var input_password;
var lbl_response_message;
var chk_accept;
var chk_news;
var http_request_registro;
var http_request_login;

signal hideSignUpMenu;
signal showLoginMenu;

# Called when the node enters the scene tree for the first time.
func _ready():
	input_email = $CntJuego/CntEmailBox/LEEmail;
	input_username = $CntJuego/CntUsernameBox/LEUsername;
	input_password = $CntJuego/CntPasswordBox/LEPassword;
	http_request_registro = $CntJuego/CntBtnRegistrarse/HTTPRequestRegistro;
	http_request_login = $CntJuego/CntBtnRegistrarse/HTTPRequestLogin;
	lbl_response_message = $CntJuego/CntResponseMessage/LblResponseMessage;
	chk_accept = $CntJuego/CntAcceptBox/BtnAccept/ChkAccept;
	chk_news = $CntJuego/CntNewsBox/BtnNews/ChkNews;
	http_request_registro.request_completed.connect(_on_request_registro_completed);
	http_request_login.request_completed.connect(_on_request_login_completed);
	pass # Replace with function body.

func _on_request_login_completed(result, response_code, headers, body):
	if (response_code != 200):
		lbl_response_message.text = "Error al entrar.";
		return;
	var json = JSON.parse_string(body.get_string_from_utf8());
	Autoload.setCredentialToken(json.token);
	Autoload.loadProfile(%HTTPRequestProfileSignUp);
	hideSignUpMenu.emit();

func _on_request_registro_completed(result, response_code, headers, body):
	if (response_code != 200):
		lbl_response_message.text = "Error al registrarse. El password deben ser mínimo 8 carácteres.";
		return;
	login();

func login():
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
	http_request_login.request(url, headers, HTTPClient.METHOD_POST, json);

func _on_btn_registrarse_pressed():
	if input_username.text == "":
		lbl_response_message.text = "Debes rellenar el usuario.";
		return;
	if input_email.text == "":
		lbl_response_message.text = "Debes rellenar el email.";
		return;
	if input_password.text == "":
		lbl_response_message.text = "Debes rellenar el password.";
		return;
	if chk_accept.button_pressed == false:
		lbl_response_message.text = "Debes aceptar las condiciones.";
		return;
	var data_to_send = {
		"name": input_username.text,
		"email": input_email.text,
		"password": input_password.text,
		"newsletter": chk_news.button_pressed,
	};
	var json = JSON.stringify(data_to_send);
	var headers = [
		"Content-Type: application/json",
		"Access-Control-Allow-Origin: *"
	];
	var url = Autoload.apiBase + "/register";
	http_request_registro.request(url, headers, HTTPClient.METHOD_POST, json);

func _on_btn_login_pressed():
	showLoginMenu.emit();
	pass # Replace with function body.

func _on_btn_accept_pressed():
	chk_accept.button_pressed = !chk_accept.button_pressed;

func _on_btn_news_pressed():
	chk_news.button_pressed = !chk_news.button_pressed;

func _on_btn_ver_condiciones_pressed():
	OS.shell_open("https://madfenix.com/condiciones");
