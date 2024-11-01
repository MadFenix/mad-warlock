extends Node

@export_file("*.tscn") var main_menu_scene : String = "res://scenes/Menus/MainMenu/MainMenu.tscn"

signal level_won
signal level_ranking
signal level_home
signal level_lost
signal level_won_finally

func _ready():
	GameState.openInfo.connect(openInfoFunctionality)
	GameState.closeInfo.connect(closeInfoFunctionality)
	Autoload.loggedOut.connect(loggedOutFunctionality)
	if GameState.firstViewToBase:
		GameState.firstViewToBase = false
		#GameState.openInfo.emit()

func loggedOutFunctionality():
	SceneLoader.load_scene(main_menu_scene)
	InGameMenuController.close_menu()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func openInfoFunctionality():
	$Information.visible = true

func closeInfoFunctionality():
	$Information.visible = false

func _on_lose_button_pressed():
	emit_signal("level_lost")

func _on_win_button_pressed():
	emit_signal("level_won")

func next_section():
	emit_signal("level_won")

func _on_summary_run_credits():
	level_lost.emit()

func _on_summary_win_run_credits():
	level_won_finally.emit()

func test_dialog():
	if Dialogic.current_timeline != null:
		return
	
	Dialogic.start('won')

func _on_back_pressed():
	emit_signal("level_home")

func _on_arena_cnt_run_back():
	emit_signal("level_home")
