class_name MainMenu
extends Control

const NO_VERSION_NAME : String = "0.0.0"

## Defines the path to the game scene. Hides the play button if empty.
@export_file("*.tscn") var game_scene_path : String
@export var options_packed_scene : PackedScene
@export var login_packed_scene : PackedScene
@export var signup_packed_scene : PackedScene
@export var credits_packed_scene : PackedScene
@export var texture_title_ca : Texture2D
@export var texture_title_en : Texture2D
@export var texture_title_es : Texture2D
@export_group("Version")
## Displays the value of `application/config/version`, set in project settings.
@export var show_version : bool = true
## Prefixes the value of `application/config/version` when displaying to the user.
@export var version_prefix : String = "v"

var options_scene
var login_scene
var signup_scene
var credits_scene
var sub_menu

var button_sound : Node

func load_scene(scene_path : String):
	SceneLoader.load_scene(scene_path)

func play_game():
	if !Autoload.getCredentialToken():
		_open_sub_menu(login_scene)
		return
	SceneLoader.load_scene(game_scene_path)

func _open_sub_menu(menu : Control):
	sub_menu = menu
	sub_menu.show()
	%BackButton.show()
	%MenuContainer.hide()

func _close_sub_menu():
	if sub_menu == null:
		return
	sub_menu.hide()
	sub_menu = null
	%BackButton.hide()
	%MenuContainer.show()

func _event_is_mouse_button_released(event : InputEvent):
	return event is InputEventMouseButton and not event.is_pressed()

func _event_skips_intro(event : InputEvent):
	return event.is_action_released("ui_accept") or \
		event.is_action_released("ui_select") or \
		event.is_action_released("ui_cancel") or \
		_event_is_mouse_button_released(event)

func _input(event):
	if event.is_action_released("ui_accept") and get_viewport().gui_get_focus_owner() == null:
		%MenuButtons.focus_first()

func _setup_for_web():
	if OS.has_feature("web"):
		%ExitButton.hide()

func _setup_version_name():
	var version_name : String = ProjectSettings.get_setting("application/config/version", NO_VERSION_NAME)
	if version_name.is_empty():
		version_name = NO_VERSION_NAME
	AppLog.version_opened(version_name)
	%VersionNameLabel.text = version_prefix + version_name
	%VersionNameLabel.visible = show_version

func _setup_play():
	if game_scene_path.is_empty():
		%PlayButton.hide()

func _setup_options():
	if options_packed_scene == null:
		%OptionsButton.hide()
	else:
		options_scene = options_packed_scene.instantiate()
		options_scene.hide()
		%OptionsContainer.call_deferred("add_child", options_scene)

func _setup_login_logout_buttons():
	var token = Autoload.getCredentialToken()
	if token:
		%LoginButton.hide()
		%LogoutButton.show()
	else:
		%LoginButton.show()
		%LogoutButton.hide()

func _setup_login():
	_setup_login_logout_buttons()
	
	if login_packed_scene == null:
		%LoginContainer.hide()
	else:
		login_scene = login_packed_scene.instantiate()
		login_scene.hide()
		if login_scene.has_signal("hideLoginMenu"):
			login_scene.connect("hideLoginMenu", login_done_from_login)
		if login_scene.has_signal("showRegisterMenu"):
			login_scene.connect("showRegisterMenu", signup_button_pressed_from_login)
		%LoginContainer.call_deferred("add_child", login_scene)

func _setup_signup():
	if signup_packed_scene == null:
		%SignUpContainer.hide()
	else:
		signup_scene = signup_packed_scene.instantiate()
		signup_scene.hide()
		if signup_scene.has_signal("hideSignUpMenu"):
			signup_scene.connect("hideSignUpMenu", login_button_pressed_from_login)
		if signup_scene.has_signal("showLoginMenu"):
			signup_scene.connect("showLoginMenu", login_button_pressed_from_login)
		%SignUpContainer.call_deferred("add_child", signup_scene)

func _setup_credits():
	if credits_packed_scene == null:
		%CreditsButton.hide()
	else:
		credits_scene = credits_packed_scene.instantiate()
		credits_scene.hide()
		if credits_scene.has_signal("end_reached"):
			credits_scene.connect("end_reached", _on_credits_end_reached)
		%CreditsContainer.call_deferred("add_child", credits_scene)

func _ready():
	button_sound = %ButtonSound
	_on_spanish_button_pressed()
	_setup_for_web()
	_setup_version_name()
	_setup_options()
	_setup_login()
	_setup_signup()
	_setup_credits()
	_setup_play()
	instanceButtonsSoundSignals()
	setTitleByLangue()

func instanceButtonsSoundSignals():
	var buttons: Array = get_tree().get_nodes_in_group("Button")
	for inst in buttons:
		inst.pressed.connect(on_button_pressed)

func on_button_pressed():
	button_sound.play()

func setTitleByLangue():
	var language = TranslationServer.get_locale()
	if language == 'en':
		%LogoTextureRect.texture = texture_title_en
	elif language == 'ca':
		%LogoTextureRect.texture = texture_title_ca
	else:
		%LogoTextureRect.texture = texture_title_es

func _on_play_button_pressed():
	play_game()

func _on_options_button_pressed():
	_open_sub_menu(options_scene)

func _on_credits_button_pressed():
	_open_sub_menu(credits_scene)
	credits_scene.reset()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_english_button_pressed():
	TranslationServer.set_locale('en')
	GameState.language = 'en'
	setTitleByLangue()

func _on_spanish_button_pressed():
	TranslationServer.set_locale('es')
	GameState.language = 'es'
	setTitleByLangue()

func _on_catalan_button_pressed():
	TranslationServer.set_locale('ca')
	GameState.language = 'ca'
	setTitleByLangue()

func _on_credits_end_reached():
	if sub_menu == credits_scene:
		_close_sub_menu()

func _on_back_button_pressed():
	_close_sub_menu()

func _on_login_button_pressed():
	_open_sub_menu(login_scene)

func login_done_from_login():
	_on_back_button_pressed()
	_setup_login_logout_buttons()

func signup_button_pressed_from_login():
	_on_back_button_pressed()
	_open_sub_menu(signup_scene)

func login_button_pressed_from_login():
	_on_back_button_pressed()
	_open_sub_menu(login_scene)


func _on_logout_button_pressed():
	Autoload.setCredentialToken('')
	_setup_login_logout_buttons()
