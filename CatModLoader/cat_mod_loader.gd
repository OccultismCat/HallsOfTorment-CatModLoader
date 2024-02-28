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
	print("")
	for log in logs:
		cat_log(log)
	print("")
	
func on_cooldown() -> bool:
	return input_timer < 0.1
	#return (Engine.get_process_frames() - input_timer) < (60 * 3)
	
func reset_cooldown():
	input_timer = 0.0
	
func get_world():
	return Global.World
	
func get_current_scene():
	return GameState.CurrentScene
	
func get_current_scene_name():
	return GameState._stateScenes[GameState.CurrentState]
	
func get_game_states():
	var states : Array = []
	for state in GameState.States:
		states.append(state)
	if states != []:
		return states
		
func get_current_game_state():
	var states = get_game_states()
	return states[GameState.CurrentState]
		
func get_current_game_state_id():
	return GameState.CurrentState
	
func set_game_state(state):
	var states = get_game_states()
	cat_log('Setting New GameState!', states[state])
	GameState.SetState(state) #GameState.States.RegisterOfHalls
	
func get_player_pos():
	return Global.World.get_player_position()
	
func get_player():
	return Global.World.Player
	
func add_player_pos(x, y):
	var current_pos = get_player_pos()
	var player_pos = get_player()
	var set_pos = player_pos.getChildNodeWithMethod("set_worldPosition")
	if set_pos:
		current_pos.x = current_pos.x + x
		current_pos.y = current_pos.y + y
		set_pos.set_worldPosition(current_pos)

func set_player_pos(x, y):
	var current_pos = get_player_pos()
	var player_pos = get_player()
	var set_pos = player_pos.getChildNodeWithMethod("set_worldPosition")
	if set_pos:
		current_pos.x = x
		current_pos.y = y
		set_pos.set_worldPosition(current_pos)

func reset_player_health():
	var playerHealthComp = CatModLoader.get_player().getChildNodeWithMethod("resetToMaxHealth")
	if playerHealthComp != null:
		cat_log('Resetting Player Health!')
		playerHealthComp.resetToMaxHealth()
		playerHealthComp.force_health_update_signals()
	
func collect_all_xp():
	cat_log("Collecting All XP!")
	var player = CatModLoader.get_player()
	var collectAllXPNode = player.getChildNodeWithMethod("collectAllXP")
	if collectAllXPNode != null:
		collectAllXPNode.collectAllXP()
	
func toggle_autoplayer(value: bool):
	ProjectSettings.set_setting("halls_of_torment/development/enable_autoplayer", value)
	var setting = ProjectSettings.get_setting("halls_of_torment/development/enable_autoplayer")

func cat_log(text, extra=null):
	var mod = "[CatModLoader]: "
	if typeof(text) == TYPE_STRING:
		print(mod + text)
	else:
		print(mod + str(text))
	if extra != null:
		if typeof(extra) == TYPE_STRING:
			print(mod + extra)
		else:
			print(mod + str(extra))
	print("")
	
func cat_debug(script, function, value=null):
	var mod = "[CatModLoader]: "
	if value != null:
		print(mod + ' | [' + script + '] | [' + function + '] | ' + str(value))
	else:
		print(mod + ' | [' + script + '] | ')
	
func print_mod_controls():
	cat_log('[1] - Prints CatModLoader Log')
	
func _ready():
	if mods_loaded == false:
		get_all_mods()
		print_loader_text()
	
func _process(delta):
	if GameState.CurrentState == GameState.States.Overworld and get_current_scene() != null:
		if mods_loaded == false:
			print_mod_controls()
		mods_loaded = true
		set_game_state(GameState.States.RegisterOfHalls)
	if mods_loaded == true:
		input_timer += delta
		if Input.is_key_pressed(KEY_1) and not on_cooldown():
			print_loader_text()
			reset_cooldown()

#func load_mods():
#	var project_path = OS.get_executable_path()
#	print(str(project_path))
