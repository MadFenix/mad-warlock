extends Node

@export var home : Node;

# Called when the node enters the scene tree for the first time.
func _ready():
	Autoload.loadProfile(%HTTPRequestProfile)

func _on_profile_btn_pressed():
	OS.shell_open("https://madfenix.com/perfil");

func _on_season_btn_pressed():
	OS.shell_open("https://madfenix.com/temporada");

func _on_ranking_btn_pressed():
	home.emit_signal("level_home")
