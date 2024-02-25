extends Node2D

var input_timer = 0.0

func input_on_cooldown(seconds) -> bool:
	return input_timer < seconds
	
func reset_cooldown():
	input_timer = 0.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(delta):
	input_timer += delta
	if Input.is_key_pressed(KEY_X):
		get_tree().quit()
	if Input.is_action_just_pressed("DebugMenu") and not input_on_cooldown(0.5):
		var current_game_state = CatModLoader.get_current_game_state_id()
		if current_game_state == GameState.States.InGame:
			CatModLoader.set_game_state(GameState.States.Debug)
		elif current_game_state == GameState.States.Debug:
			CatModLoader.set_game_state(GameState.States.InGame)
		elif current_game_state == GameState.States.Paused:
			CatModLoader.set_game_state(GameState.States.InGame)
		reset_cooldown()
	
	if Input.is_key_pressed(KEY_F10) and not input_on_cooldown(0.5):
		CatModLoader.set_game_state(GameState.States.PlayerSurvived)
		reset_cooldown()
	
	if Input.is_key_pressed(KEY_F9) and not input_on_cooldown(0.5):
		CatModLoader.set_game_state(GameState.States.RegisterOfHalls)
		reset_cooldown()
		
	if Input.is_key_pressed(KEY_F8) and not input_on_cooldown(0.5):
		CatModLoader.collect_all_xp()
		reset_cooldown()
		
	if Input.is_key_pressed(KEY_F7) and not input_on_cooldown(0.5):
		Global.World.trigger_finale()
		reset_cooldown()
