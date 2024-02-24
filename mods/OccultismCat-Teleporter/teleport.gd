extends Control

func _ready():
	pass
	
func _process(delta):
	if Input.is_key_pressed(KEY_F1):
		var player = CatModLoader.get_player()
		if Global.is_world_ready() and player != null:
			CatModLoader.set_player_pos(4, 4)
	if Input.is_key_pressed(KEY_F2):
		var player = CatModLoader.get_player()
		if Global.is_world_ready() and player != null:
			var pos = CatModLoader.get_player_pos()
			print(pos)
