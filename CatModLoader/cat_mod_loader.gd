extends Control

var mod = 'CatModLoader'
var ver = '0.1.2'

var logs : Array
var mod_settings = {}
var mods_folder := OS.get_executable_path().get_base_dir() + "/mods/"
var mods_dir := DirAccess.open(mods_folder)
var mods_loaded : bool = false
var input_timer = 0.0

var nums := []

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
		logs.append(file.to_upper())
			
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

func load_mod_settings():
	var settings_file = "settings.json"
	var settings_text = FileAccess.get_file_as_string(settings_file)
	var settings = JSON.parse_string(settings_text)
	CatModLoader.cat_mod(mod, 'Settings has been loaded!')
	return settings

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if mods_loaded == false:
		mod_settings = load_mod_settings()
		toggle_autoplayer(mod_settings['mod_settings']['auto_player'])
		get_all_mods()
	
func _process(delta):
	var items : Array = [TraitSelection.Selection.Gold, TraitSelection.Selection.Health]
	if GameState.CurrentState == GameState.States.Overworld and get_current_scene() != null:
		if mods_loaded == false:
			print_mod_controls()
			quick_play()
			#set_game_state(GameState.States.RegisterOfHalls)
		mods_loaded = true
	if mods_loaded == true:
		input_timer += delta
		if GameState.CurrentState == 5:
			if GlobalMenus.traitSelectionUI.currentState == TraitSelection.States.AlmsSelection:
				GlobalMenus.traitSelectionUI.select(items.pick_random())
			elif GlobalMenus.traitSelectionUI.currentState == TraitSelection.States.NormalTraitSelection:
				GlobalMenus.traitSelectionUI.select(TraitSelection.Selection.Trait1)
			GlobalMenus.traitSelectionUI.on_selection_confirmed(true)
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

## Modding Functions ##
func create_timer():
	pass

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

func get_player_world_pos():
	return Global.World.Player.getChildNodeWithMethod('get_worldPosition')
	
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

func spawn_pickup():
	pass

func spawn_object():
	pass


func spawn(item, global_pos=false, valid=true, player_position=false, custom_pos=null):
	var spawn_item = item
	if typeof(item) == TYPE_STRING:
		spawn_item = ResourceLoaderQueue.getCachedResource(item)
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
	if custom_pos != null:
		spawned.global_position = custom_pos
	Global.attach_toWorld(spawned)
	#cat_log('Spawned new item/enemy/object', spawn_item._bundled.names[0])
	return spawned

signal spawned_fx

func spawn_fx(fx, player_world_pos=true, custom_pos=null):
	if not fx:
		return
	var spawn_fx = fx
	if typeof(spawn_fx) == TYPE_STRING:
		spawn_fx = await ResourceLoaderQueue.getCachedResource(spawn_fx)
		await ResourceLoaderQueue.waitForLoadingFinished()
	var pos = Vector2.ZERO
	var player_pos = get_player_pos()
	pos.x = player_pos.x
	pos.y = player_pos.y
	var spawned_fx = spawn_fx.instantiate()
	spawned_fx.global_position = pos
	Global.attach_toWorld(spawned_fx)
	return spawned_fx

func set_fx_indicator_text(fx_indicator:Node2D):
	if not fx_indicator and not is_instance_valid(fx_indicator):
		return

func spawn_fx_indicator(text, player_pos=true, custom_pos=null):
	var fx_indicator = await ResourceLoaderQueue.getCachedResource('res://FX/text_indicator/text_indicator.tscn')
	await ResourceLoaderQueue.waitForLoadingFinished()
	var spawned_fx_indicator = fx_indicator.instantiate()
	var pos = CatModLoader.get_player_pos()
	spawned_fx_indicator.global_position = pos
	Global.attach_toWorld(spawned_fx_indicator)
	#CatModLoader.cat_mod(mod, 'fx indicator', fx_indicator._bundled)
	#fx_indicator.set_script('res://mods/OccultismCat-ModUtils/spawn_fx_indicator.gd')
	var fx_indicator_text_node = spawned_fx_indicator.get_node('Container/Label')
	var fx_indicator_icon_node = spawned_fx_indicator.get_node('Container/Icon')
	fx_indicator_text_node.text = str(text)
	spawned_fx_indicator.scale = (Vector2.ONE * 0.1)
	spawned_fx_indicator.Lifetime = 3
	spawned_fx_indicator.play()
	return spawned_fx_indicator


func spawn_text_fx(text, icon='', size=1, lifetime=2.5, global_pos=false, player_position=true, text_color=Color(1,1,1,1), icon_color=Color(1,1,1,1), custom_pos=null):
	var text_fx = await ResourceLoaderQueue.getCachedResource('res://FX/text_indicator/text_indicator.tscn')
	if typeof(icon) == TYPE_STRING:
		icon = await ResourceLoaderQueue.getCachedResource(icon)
	await ResourceLoaderQueue.waitForLoadingFinished()
	var spawned_text_fx = await spawn(text_fx, global_pos, false, player_position, custom_pos)
	#spawned_text_fx.global_position = 
	var spawned_text_node = spawned_text_fx.get_node('Container/Label')
	var spawned_icon_node = spawned_text_fx.get_node('Container/Icon')
	spawned_text_node.text = str(text)
	spawned_text_node.modulate = text_color
	spawned_icon_node.set_texture(icon)
	spawned_icon_node.modulate = icon_color
	spawned_text_fx.scale = (Vector2.ONE * size)
	spawned_text_fx.Lifetime = lifetime
	spawned_text_fx.play()

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
	cat_mod('Controls', "Key] [1] = Print Log")
	cat_mod('Controls', "Key] [Shift + 1] = Quick Play")