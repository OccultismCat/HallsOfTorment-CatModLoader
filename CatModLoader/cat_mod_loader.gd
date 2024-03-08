extends Control

var mod = 'CatModLoader'
var ver = '0.1.0'

var logs : Array
var mods_folder := OS.get_executable_path().get_base_dir() + "/mods/"
var mods_dir := DirAccess.open(mods_folder)
var mods_loaded : bool = false
var input_timer = 0.0

var nums := []

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
	
func load_mod(path, file):
	var mod_script = await ResourceLoader.load(path + '/' + file)
	if mod_script:
		var mod_script_instance = mod_script.new()
		add_child(mod_script_instance)
		cat_mod(mod_script_instance.mod, 'Found & Loaded Mod', 'Version', mod_script_instance.ver)
		logs.append('[CatModLoader] | ')
		logs.append("[CatModLoader] | Found & Loaded Mod: " + file.to_upper())
			
func load_mods_from_folder(path):
	var inner_mod_folder = DirAccess.open(path)
	if inner_mod_folder:
		inner_mod_folder.list_dir_begin()
		var file = inner_mod_folder.get_next()
		while file != "":
			load_mod(path, file)
			file = inner_mod_folder.get_next()
	
func print_loader_text():
	print("")
	for log in logs:
		cat_log(log)
	print("")
	
func on_cooldown(seconds) -> bool:
	return input_timer < seconds
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
		playerHealthComp.resetToMaxHealth()
		playerHealthComp.force_health_update_signals()
	
func get_player_level():
	return Global.World.Level

func add_player_xp(amount, modifier=true):
	var current_level = Global.World.Level
	Global.World.addExperience(amount, modifier)

func set_player_xp(amount):
	var current_level = Global.World.Level
	var new_level = Global.World.getLevelUpExperience(current_level + amount)
	Global.World.addExperience(new_level)

func collect_all_xp():
	var player = CatModLoader.get_player()
	var collectAllXPNode = player.getChildNodeWithMethod("collectAllXP")
	if collectAllXPNode != null:
		collectAllXPNode.collectAllXP()
	0

func find_in_list(list, search):
	cat_log('Find In List', list.find(search))
	cat_log('Find In List', list.count(search))
	if list.find(1) != -1:
		print("it worked")
		return true
	else:
		return false

func get_random_number(min=null, max=null):
	if max:
		if len(nums) != max:
			nums = []
			var count = 1
			if min:
				count = min
			while count <= max:
				nums.append(count)
				count += 1
	else:
		nums = [5, 6, 7, 8, 9, 10]
	var rand_num = nums.pick_random()
	return rand_num

func get_enemys():
	var all_enemys : Array = []
	var slimes = ['res://GameElements/Monsters/Slime_gold_small.tscn', 'res://GameElements/Monsters/Stage01/Slime_basic.tscn', 'res://GameElements/Monsters/Stage01/Slime_green.tscn', 'res://GameElements/Monsters/Stage02/Slime_magma_reactive.tscn', 'res://GameElements/Monsters/Stage02/Slime_magma.tscn', 'res://GameElements/Monsters/Stage02/Slime_magma_small.tscn', 'res://GameElements/Monsters/Stage02/Slime_magma_elite.tscn', 'res://GameElements/Monsters/Stage02/Slime_magma_elite2.tscn']
	all_enemys.append_array(slimes)
	var enemys : Array = all_enemys
	return enemys

func get_enemy():
	var enemys = get_enemys()
	var random_enemy = ''
	random_enemy = enemys.pick_random()
	return random_enemy

func get_random_enemys(amount):
	if not amount:
		return
	var random_enemys : Array = []
	var random_amount = get_random_number(1, amount)
	while random_enemys.size() < random_amount:
		var random_enemy = get_enemy()
		random_enemys.append(random_enemy)
	return random_enemys

func get_boss():
	var all_bosses = []
	var boss_wave_list = []
	var random_boss = ''
	var stage_1 = ["res://GameElements/Monsters/Stage01/Imp_boss.tscn", "res://GameElements/Monsters/Stage01/Lich_boss.tscn", "res://GameElements/Monsters/Stage01/Skeleton_boss.tscn",]
	var stage_2 = ["res://GameElements/Monsters/Stage02/Flamedancer_boss.tscn", "res://GameElements/Monsters/Stage02/Wraith_Warlord_boss.tscn", "res://GameElements/Monsters/Stage02/wyrm_boss.tscn", "res://GameElements/Monsters/Stage02/wyrm_boss_body.tscn"]
	var stage_3 = ["res://GameElements/Monsters/Stage03/Frost_Knight_boss.tscn", "res://GameElements/Monsters/Stage03/Hydra_boss.tscn", "res://GameElements/Monsters/Stage03/Wraith_Horseman_boss.tscn"]
	var stage_4 = ["res://GameElements/Monsters/Stage04/Basilisk_Boss.tscn", "res://GameElements/Monsters/Stage04/Elder_Giant_Boss.tscn", "res://GameElements/Monsters/Stage04/Twisted_Construct_Boss.tscn"]
	var stage_5 = ["res://GameElements/Monsters/Stage05/Twisted_Knight_Boss.tscn", "res://GameElements/Monsters/Stage05/Village_Boss.tscn", "res://GameElements/Monsters/Stage05/Voidcaller_Boss.tscn"]
	boss_wave_list = [stage_1, stage_2, stage_3, stage_4, stage_5]
	for boss_wave in boss_wave_list:
		for boss in boss_wave:
			all_bosses.append(boss)
	random_boss = all_bosses.pick_random()
	return random_boss

func spawn_pickup():
	pass

func spawn_object():
	pass

func spawn_fx():
	pass

func spawn(item, global_pos=false, valid=true, player_position=false):
	var spawn_item = ResourceLoaderQueue.getCachedResource(item)
	await ResourceLoaderQueue.waitForLoadingFinished()
	var pos = Vector2.ZERO
	if global_pos == true:
		var player_pos = get_player_pos()
		pos.x = player_pos.x
		pos.y = player_pos.y
	else:
		pos += Vector2(randf_range(0, 0), randf_range(0, 0))
	if player_position == true:
		var player_pos = CatModLoader.get_player_pos()
		pos.x = player_pos.x
		pos.y = player_pos.y
	if valid == true:
		pos = Global.World.OffscreenPositioner.get_nearest_valid_position(pos)
	var spawned = spawn_item.instantiate()
	spawned.global_position = pos
	Global.attach_toWorld(spawned)
	#cat_log('Spawned new item/enemy/object', spawn_item._bundled.names[0])
	return spawned

func toggle_autoplayer(value: bool):
	ProjectSettings.set_setting("halls_of_torment/development/enable_autoplayer", value)
	var setting = ProjectSettings.get_setting("halls_of_torment/development/enable_autoplayer")

func quick_play():
	Global.WorldsPool.enterWorld(3, false)

func cat_log(text, extra=null):
	var mod = "[CatModLoader] | "
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
	var mod = "[CatModLoader] | "
	if value != null:
		print(mod + '[' + script + '] | [' + str(function) + '] | [' + str(value) + ']')
	else:
		print(mod + '[' + script + '] | [' + str(function) + ']')
	
func cat_mod(script, function, value=null, data=null):
	var mod = '[CatModLoader] | '
	var print_text = mod
	if value != null:
		if data != null:
			print_text += '[' + script + '] | [' + function + '] | [' + str(value) + '] | [' + str(data) + ']'
		else:
			print_text += '[' + script + '] | [' + function + '] | [' + str(value) + ']'
	else:
		print_text += '[' + script + '] | [' + function + ']'
	print(print_text)

func print_mod_controls():
	cat_log('[1] - Prints CatModLoader Log')


func _ready():
	if mods_loaded == false:
		toggle_autoplayer(true)
		get_all_mods()
		print_loader_text()
	
func _process(delta):
	if GameState.CurrentState == GameState.States.Overworld and get_current_scene() != null:
		if mods_loaded == false:
			print_mod_controls()
			quick_play()
			#set_game_state(GameState.States.RegisterOfHalls)
		mods_loaded = true
	if mods_loaded == true:
		input_timer += delta
		if Input.is_key_pressed(KEY_1) and not Input.is_key_pressed(KEY_SHIFT) and not on_cooldown(1):
			reset_cooldown()
			print_loader_text()
		## Quick Exit ##
		if Input.is_key_pressed(KEY_1) and Input.is_key_pressed(KEY_SHIFT) and not on_cooldown(1):
			if get_current_game_state_id() == GameState.States.InGame:
				GameState.TransitionToState(GameState.States.Overworld, 0.2)
			else:
				quick_play()
			reset_cooldown()