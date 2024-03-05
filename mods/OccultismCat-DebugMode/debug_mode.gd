extends Node2D

var input_timer = 0.0

var loop_toggle = false
var loop_timer = 0.0

func input_on_cooldown(seconds) -> bool:
	return input_timer < seconds
	
func loop_on_cooldown(seconds) -> bool:
	return loop_timer < seconds
	
func reset_cooldown():
	input_timer = 0.0
	
func loop_reset_cooldown():
	loop_timer = 0.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta):
	input_timer += delta
	loop_timer += delta
	if Input.is_key_pressed(KEY_Q):
		Global.quit_game()
		
	if Input.is_key_pressed(KEY_QUOTELEFT) and not input_on_cooldown(0.5):
		var current_game_state = CatModLoader.get_current_game_state_id()
		if current_game_state == GameState.States.InGame:
			CatModLoader.set_game_state(GameState.States.Debug)
		elif current_game_state == GameState.States.Debug:
			CatModLoader.set_game_state(GameState.States.InGame)
		elif current_game_state == GameState.States.Paused:
			CatModLoader.set_game_state(GameState.States.InGame)
		reset_cooldown()
	
	if Input.is_key_pressed(KEY_9) and not Input.is_key_pressed(KEY_SHIFT) and not input_on_cooldown(0.5):
		CatModLoader.set_game_state(GameState.States.PlayerSurvived)
		reset_cooldown()
	
	if Input.is_key_pressed(KEY_9) and Input.is_key_pressed(KEY_SHIFT) and not input_on_cooldown(0.5):
		CatModLoader.set_game_state(GameState.States.RegisterOfHalls)
		reset_cooldown()
		
	if Input.is_key_pressed(KEY_8) and not input_on_cooldown(0.5):
		CatModLoader.collect_all_xp()
		reset_cooldown()
		
	if Input.is_key_pressed(KEY_7) and not input_on_cooldown(0.5):
		Global.World.trigger_finale()
		reset_cooldown()
	
	if Input.is_key_pressed(KEY_6) and not input_on_cooldown(0.5):
		var items : Array = ['head_warcry', 'head_battlerage', 'neck_gatherers_charm', 'ring_sealofrebirth', 'ring_ratring', 'body_vampirism', 'feet_septicboots', 'hand_quickhand']
		for item in items:
			var new_item = Global.ItemsPool.find_item_with_id(item)
			if new_item:
				CatModLoader.cat_log('Equipping new item! ', item)
				Global.ItemsPool.equip_item(new_item, CatModLoader.get_player())
		reset_cooldown()

	if Input.is_key_pressed(KEY_5) and not input_on_cooldown(1):
		#CatModLoader.reset_player_health()
		var weapons : Array = [606, 614, 615]
		for weapon in weapons:
			var new_item = Global.ItemsPool.find_item_with_weapon_index(weapon)
			CatModLoader.cat_log('Equipping items!', weapons)
			if new_item:
				#CatModLoader.cat_log('Equipping new item! ', weapon)
				Global.ItemsPool.equip_item(new_item, CatModLoader.get_player())
		reset_cooldown()
		
	if Input.is_key_pressed(KEY_4) and not input_on_cooldown(1):
		reset_cooldown()
		var trait_levels = ['I', 'II', 'III', 'IV', 'V']
		var trait_extras = [' (fast)', ' (weak)', ' (strong)', ' (Regeneration)', ' (Speed)', ' (Quickdraw)', ' (Pierce)', ' (Agility)', ' (Pinpoint)', ' (Charging)']
		var traits = ['Strength ', 'Cunning Technique ', 'Metabolism ', 'Quick Hands ', 'Channeling ', 'Collateral Damage ', 'Vitality', 'Vanguard', 'Ruthlessness', 'Swift Feet ', 'Thick Hide ', 'Parry ', 'Dedication ', 'Arcane Splinter ', 'Proficient Stance ', 'Weapon Proficiency ']
		for level in trait_levels:
			for t in traits:
				var new_trait = Global.World.TraitPool.get_trait_with_name(t + level)
				if new_trait:
					new_trait.acquire_trait(CatModLoader.get_player())
					for extra in trait_extras:
						new_trait = Global.World.TraitPool.get_trait_with_name(t + level + extra)
						if new_trait:
							new_trait.acquire_trait(CatModLoader.get_player())
		#Global.World.TraitPool.trait_changed_state(traits, 2)
		
	if Input.is_key_pressed(KEY_3) and not input_on_cooldown(0.1):
		if CatModLoader.get_current_game_state_id() != GameState.States.InGame:
			return
		reset_cooldown()
		for item in Global.World.Pickups.items:
			CatModLoader.cat_log('pickup', item)
			var pickup = item.instantiate()
			CatModLoader.cat_log('pickup', pickup)
		#var pickup_scene = Global.World.Pickups.pick_item()
		#CatModLoader.cat_log('pickup_scene', pickup_scene)
		#var pickup = pickup_scene.instantiate()

			#CatModLoader.cat_log('pickup', Global.World.Pickups.items)
			var pos = CatModLoader.get_player_pos()
			#pos.x += 150
			pos = Global.World.OffscreenPositioner.get_nearest_valid_position(pos)
			CatModLoader.cat_log('pickup pos', pos)
			pickup.global_position = pos
			Global.attach_toWorld(pickup)
			
	if Input.is_key_pressed(KEY_2) and not Input.is_key_pressed(KEY_SHIFT) and not input_on_cooldown(1):
		reset_cooldown()
		if CatModLoader.get_current_game_state_id() != GameState.States.InGame:
			return
		var current_level = Global.World.Level
		CatModLoader.cat_log('', current_level)
		var new_level = Global.World.getLevelUpExperience(current_level + 1)
		CatModLoader.cat_log('', new_level)
		Global.World.addExperience(new_level, true)
		#Global.World.emit_signal("ExperienceThresholdReached")
		#Global.World.addExperience(9999999, false)
		#CatModLoader.cat_log('', XPGemPool)
		#CatModLoader.cat_log('', XPGemPoolItem)
		#var gem = GemPool.get_biggest_smaller_than_target(10.0)
		#var gem = XPGemPool.get_biggest_smaller_than_target(10.0) #Global.SpawnXpOnDeath.GemPool.get_biggest_smaller_than_target(10)
		#var menu = GlobalMenus.hud
		#CatModLoader.cat_debug('', '', menu)
		#menu.onGoldChanged(1000)
		
	if Input.is_key_pressed(KEY_2) and Input.is_key_pressed(KEY_SHIFT) and not input_on_cooldown(0.1):
		reset_cooldown()
		if CatModLoader.get_current_game_state_id() != GameState.States.InGame:
			return
		var current_level = Global.World.Level
		CatModLoader.cat_log('', current_level)
		var new_level = Global.World.getLevelUpExperience(current_level + 1)
		CatModLoader.cat_log('', new_level)
		Global.World.addExperience(new_level, true)
		#var current_gold = Global.World.Gold
		#CatModLoader.cat_log('', current_gold)
		#Global.World.addGold(10000)
		
	#if loop_toggle == true:
	#	
	#	if not loop_on_cooldown(1):
	#		var random_wait = CatModLoader.get_random_number()
	#		if not loop_on_cooldown(random_wait):
	#			CatModLoader.cat_log('random_wait', random_wait)
	#			if CatModLoader.get_current_game_state_id() != GameState.States.InGame:
	#				return
	#			CatModLoader.spawn(CatModLoader.get_enemy())
	#			CatModLoader.spawn(CatModLoader.get_boss())
	#		loop_reset_cooldown()
		
	#if Input.is_key_pressed(KEY_KP_0) and not input_on_cooldown(0.25):
	#	reset_cooldown()
	#	if loop_toggle == true:
	#		loop_toggle = false
	#	elif loop_toggle == false:
	#		loop_toggle = true
	#	CatModLoader.cat_log('Spawn Loop Toggle', loop_toggle)
