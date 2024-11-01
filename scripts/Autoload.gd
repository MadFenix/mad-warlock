extends Node

var apiBase = 'https://api.madfenix.com/api';
var game2elevadoFile;
var pathPersistedData = "user://gameData/gameMadWarlockData.tres";
var persistedData : PersistedData;
var dirPersistedData : DirAccess;
var profileUsername = '';
var profileEmail = '';
var profileDescription = '';
var profileDetails = '';
var profileAvatar = '';
var profilePlumas = 0;
var gameInPause = false;

signal menuOpened();
signal gameResume();
signal profileStatus();
signal fighterUserStatus();
signal fighterUserDeckSaved();
signal loggedOut();

func _ready():
	dirPersistedData = DirAccess.open("user://");
	menuOpened.connect(menuOpenedProcess);
	gameResume.connect(gameResumeProcess);
	load_persisted_data();
	setAudioState();

func toogleAudio(bus_idx):
	if bus_idx == 2:
		persistedData.audioMusicEnabled = !persistedData.audioMusicEnabled;
	if bus_idx == 1:
		persistedData.audioEffectsEnabled = !persistedData.audioEffectsEnabled;
	save_persisted_data();
	setAudioState();

func isGameInPause():
	return gameInPause;

func setGameInPause(value: bool):
	gameInPause = value;

func menuOpenedProcess():
	setGameInPause(true);

func gameResumeProcess():
	setGameInPause(false);

func setAudioStateTutorialEnable():
	#AudioServer.set_bus_mute(3, false); #Tutorial bus
	#AudioServer.set_bus_mute(2, true);
	#AudioServer.set_bus_mute(1, true);
	pass

func setAudioState():
	#AudioServer.set_bus_mute(3, true); #Tutorial bus
	#AudioServer.set_bus_mute(2, !persistedData.audioMusicEnabled);
	#AudioServer.set_bus_mute(1, !persistedData.audioEffectsEnabled);
	pass

func getAudioState(bus_idx):
	if bus_idx == 2:
		return persistedData.audioMusicEnabled;
	if bus_idx == 1:
		return persistedData.audioEffectsEnabled;
	return false;

func loadProfile(http_node: HTTPRequest):
	var token = getCredentialToken();
	if (token == ""):
		return;
	var data_to_send = {};
	var json = JSON.stringify(data_to_send);
	var headers = [
		"Content-Type: application/json",
		"Access-Control-Allow-Origin: *",
		"Authorization: Bearer " + token
	];
	var url = apiBase + "/profile/getUserProfile";
	http_node.request_completed.connect(_on_request_profile_completed);
	http_node.request(url, headers, HTTPClient.METHOD_POST, json);
	pass;

func _on_request_profile_completed(result, response_code, headers, body):
	if response_code == 403:
		setCredentialToken("");
		loggedOut.emit();
	if (response_code != 200):
		profileStatus.emit(response_code, "Error al cargar el perfil.");
		return;
	var json = JSON.parse_string(body.get_string_from_utf8());
	profileUsername = json.username;
	profileEmail = json.email;
	profileDescription = json.description;
	profileDetails = json.details;
	profileAvatar = json.avatar;
	profilePlumas = json.plumas;
	profileStatus.emit(response_code, "");
	pass;

func load_game_data():
	if ResourceLoader.exists(pathPersistedData):
		return load(pathPersistedData);
	return null;

func save_persisted_data():
	var dirExists = dirPersistedData.dir_exists("gameData");
	if !dirExists:
		var logMakeDir = dirPersistedData.make_dir("gameData");
	var fileExists = FileAccess.file_exists(pathPersistedData);
	if !fileExists:
		var file = FileAccess.open(pathPersistedData, FileAccess.WRITE);
		file.store_string("");
	var logSave = ResourceSaver.save(persistedData, pathPersistedData);

func load_persisted_data():
	persistedData = load_game_data();
	if persistedData == null:
		persistedData = PersistedData.new();

func setCredentialToken(token):
	persistedData.credentialToken = token;
	save_persisted_data();

func getCredentialToken():
	return persistedData.credentialToken;

func getProfilePlumas():
	return profilePlumas;

func getProfileUsername():
	return profileUsername;

func getProfileEmail():
	return profileEmail;
