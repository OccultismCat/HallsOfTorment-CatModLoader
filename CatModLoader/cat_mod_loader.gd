extends Control

var logs : Array
var mods_folder := OS.get_executable_path().get_base_dir() + "/mods/"
var mods_dir := DirAccess.open(mods_folder)
var mods_loaded : bool = false
var input_timer = 0.0

# we load and instantiate the new scene manually, according to
# https://docs.godotengine.org/en/latest/tutorials/scripting/singletons_autoload.html#custom-scene-switcher
# so that we have a little more control over it than using change_scene...

func get_all_mods():
	if mods_dir:
		mods_dir.list_dir_begin()
		var file = mods_dir.get_next()
		while file != "":
			if not file.ends_with('.gd'):
				load_mods_from_folder(mods_folder + file)
			file = mods_dir.get_next()
	if not mods_dir:
		DirAccess.make_dir_absolute(mods_folder)
	
func load_mod(mod_path):
	var mod_script = ResourceLoader.load(mod_path)
	if mod_script:
		logs.append("Mod Loaded: " + mod_path)
		add_child(mod_script.new())
			
func load_mods_from_folder(path):
	var inner_mod_folder = DirAccess.open(path)
	if inner_mod_folder:
		inner_mod_folder.list_dir_begin()
		var file = inner_mod_folder.get_next()
		while file != "":
			load_mod(path + '/' + file)
			file = inner_mod_folder.get_next()
			
func print_loader_text():
	for log in logs:
		print(log)
	
func on_cooldown() -> bool:
	return input_timer < 0.1
	#return (Engine.get_process_frames() - input_timer) < (60 * 3)
	
func reset_cooldown():
	input_timer = 0.0
	
func get_current_scene():
	return GameState.CurrentScene
	
func get_current_scene_name():
	return GameState._stateScenes[GameState.CurrentState]
	
func get_player_pos():
	return Global.World.get_player_position()
	
func set_player_pos(x, y):
	var current_pos = get_player_pos()
	var player_pos = get_player()
	var set_pos = player_pos.getChildNodeWithMethod("set_worldPosition")
	if set_pos:
		current_pos.x = current_pos.x + x
		current_pos.y = current_pos.y + y
		set_pos.set_worldPosition(current_pos)
	
func get_player():
	return Global.World.Player
	
func toggle_autoplayer(value: bool):
	ProjectSettings.set_setting("halls_of_torment/development/enable_autoplayer", value)
	var setting = ProjectSettings.get_setting("halls_of_torment/development/enable_autoplayer")
	print('ENABLE_AUTOPLAYER: ', setting)
	
func _ready():
	if mods_loaded == false:
		get_all_mods()
		toggle_autoplayer(true)
		print_loader_text()
		mods_loaded = true
	
func _process(delta):
	input_timer += delta
	if Input.is_key_pressed(KEY_1) and not on_cooldown():
		var current_scene_name = get_current_scene_name()
		var current_scene = get_current_scene()
		print(current_scene_name)
		print(current_scene)
		print_loader_text()
		reset_cooldown()
	
#func load_mods():
#	var project_path = OS.get_executable_path()
#	print(str(project_path))
