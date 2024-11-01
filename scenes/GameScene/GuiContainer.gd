extends Control

@export var GameUI : Node;

var current_level = 'home'

# Called when the node enters the scene tree for the first time.
func _ready():
	Autoload.loadProfile(%HTTPRequestProfile)

func _on_profile_btn_pressed():
	OS.shell_open("https://madfenix.com/perfil");

func _on_season_btn_pressed():
	OS.shell_open("https://madfenix.com/temporada");

func _on_change_lvl_btn_pressed():
	if current_level == 'home':
		GameUI.go_level_ranking();
		current_level = 'ranking';
	else:
		GameUI.go_level_home();
		current_level = 'home';
