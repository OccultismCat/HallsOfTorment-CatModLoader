extends Control

func _ready():
	pass
	
func _process(delta):
	if Input.is_key_pressed(KEY_F1):
		var player = Global.World.Player
		if Global.is_world_ready() and player != null:
			print(player)
			var pos = Global.World.get_player_position()
			print(pos)
			var set_pos = player.getChildNodeWithMethod("set_worldPosition")
			print(set_pos)
			if set_pos != null:
				pos.y += 50
				set_pos.set_worldPosition(pos)
	if Input.is_key_pressed(KEY_F2):
		var player = Global.World.Player
		if Global.is_world_ready() and player != null:
			var pos = Global.World.get_player_position()
			print(pos)
