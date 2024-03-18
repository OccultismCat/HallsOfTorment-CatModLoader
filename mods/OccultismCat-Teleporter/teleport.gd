extends Control

var mod = 'Teleporter'
var ver = '0.0.1'

var cooldown = 0.0
var cords_cooldown = 0.0
var selected_cords = 0
var cords : Array = [[0,0]] #[[0,0], [100,100], [200,200], [300,300], [400,400], [500,500]]
var auto_teleport : bool = false
var auto_tp_cooldown = 0.0

func on_cooldown(seconds) -> bool:
	return cooldown < seconds
	
func on_cords_cooldown(seconds) -> bool:
	return cords_cooldown < seconds

func  auto_teleport_cooldown(seconds) -> bool:
	return auto_tp_cooldown < seconds

func add_current_pos(x=null, y=null):
	var current_pos = CatModLoader.get_player_pos()
	cords.append([current_pos.x + 1, current_pos.y + 1])
	CatModLoader.cat_log("Teleporter: Adding New Position!", cords)

func teleport_to(x=null, y=null):
	var cord = cords[selected_cords]
	CatModLoader.set_player_pos(cord[0], cord[1])
	selected_cords = (selected_cords + 1) % cords.size()
	#CatModLoader.cat_log("Teleporter: Teleporting To New Position!", cords[selected_cords])

func _ready():
	pass
	
func _process(delta):
	cooldown += delta
	cords_cooldown += delta
	auto_tp_cooldown += delta
	
	# Auto Teleport #
	if Input.is_key_pressed(KEY_T) and Input.is_key_pressed(KEY_CTRL) and not on_cooldown(0.5):
		if auto_teleport == false:
			auto_teleport = true
		elif auto_teleport == true:
			auto_teleport = false
		print(auto_teleport)
		cooldown = 0.0
	if auto_teleport == true and not auto_teleport_cooldown(0.01):
		teleport_to()
		auto_tp_cooldown = 0.0
	# Save Current POS #
	if Input.is_key_pressed(KEY_T) and Input.is_key_pressed(KEY_SHIFT) and not on_cords_cooldown(0.5):
		add_current_pos()
		cords_cooldown = 0.0
	# Go to saved POS #
	if Input.is_key_pressed(KEY_T) and not Input.is_key_pressed(KEY_SHIFT) and not Input.is_key_pressed(KEY_ALT) and not on_cooldown(0.5):
		teleport_to(0, 0)
		cooldown = 0.0
	#if Input.is_key_pressed(KEY_F3):
	#	var player = CatModLoader.get_player()
	#	if Global.is_world_ready() and player != null:
	#		CatModLoader.set_player_pos(4, 4)
	if Input.is_key_pressed(KEY_T) and Input.is_key_pressed(KEY_ALT) and not on_cooldown(0.2):
		var player = CatModLoader.get_player()
		if Global.is_world_ready() and player != null:
			var pos = CatModLoader.get_player_pos()
			print(pos)
		cooldown = 0.0
