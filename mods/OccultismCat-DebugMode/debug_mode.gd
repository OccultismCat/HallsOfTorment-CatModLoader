extends Node2D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(_delta):
	if Input.is_key_pressed(KEY_X):
		get_tree().quit()
	
	if Input.is_action_just_pressed("DebugMenu"):
		if GameState.CurrentState == GameState.States.InGame:
			GameState.SetState(GameState.States.Debug)
		elif GameState.CurrentState == GameState.States.Debug:
			GameState.SetState(GameState.States.InGame)
		elif GameState.CurrentState == GameState.States.Paused:
			GameState.SetState(GameState.States.InGame)
	
	if Input.is_key_pressed(KEY_F10):
		#if GameState.CurrentState == GameState.States.InGame:
		GameState.SetState(GameState.States.PlayerSurvived)
	
	if Input.is_key_pressed(KEY_F9):
		GameState.SetState(GameState.States.RegisterOfHalls)
