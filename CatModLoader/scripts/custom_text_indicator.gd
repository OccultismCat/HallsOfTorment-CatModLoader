extends Node2D

#var mod = 'Custom Text Indicator'
#var ver = '0.0.1'

var timer = 0.0
var max_time = 0.5

var spawned_fx_indicator = null
var spawned_fx_indicator_text_node = null
var spawned_fx_indicator_icon_node = null

var lifetime : float = 1.0
var custom_scale : Vector2 = (Vector2.ONE * 1.00)
var default_text : String = ''

var follow_player : bool = false

var use_animated_text : bool = false
var text : String = ''
var selected_text : int = 0
var text_finished : bool = false

var icon = null

func set_lifetime(live_time:float):
	if not is_instance_valid(spawned_fx_indicator):
		return
	spawned_fx_indicator.Lifetime = live_time

func set_scale(scale_float:float):
	if not is_instance_valid(spawned_fx_indicator):
		return
	spawned_fx_indicator.scale = (Vector2.ONE * scale_float) 

func set_pos(pos:Vector2):
	if not is_instance_valid(spawned_fx_indicator):
		return
	spawned_fx_indicator.global_position = pos

func set_text(txt:String):
	if not is_instance_valid(spawned_fx_indicator_text_node):
		return
	spawned_fx_indicator_text_node.text = txt


func set_text_speed(speed):
	if not is_instance_valid(spawned_fx_indicator):
		return

func set_text_color(c, c2=null, c3=null):
	var alpha = 1
	var get_color = null
	var colors = {
		'red': Color(1,0,0, alpha),
		'green': Color(0,1,0, alpha),
		'blue': Color(0,0.5,1, 1),
		'yellow': Color(1, 1, 0, alpha),
		'pink': Color(1,0,0.5, alpha),
		'hot_pink': Color(1,0,1, alpha),
		'cyan': Color(0,1,1, alpha),
		'purple': Color(0.5,0,0.5, alpha)
	}
	if not is_instance_valid(spawned_fx_indicator_text_node):
		return
	if typeof(c) == TYPE_STRING:
		if c == 'random':
			get_color = colors.values()
			get_color.shuffle()
			c = get_color.pick_random()
			#CatModLoader.cat_mod(mod, 'color index', colors.find_key(c))
		else:
			get_color = colors.get(c)
			if get_color != null:
				c = get_color
	elif typeof(c) == TYPE_INT and c2 != null and c3 != null:
		c = Color(c, c2, c3, 1)
	spawned_fx_indicator_text_node.modulate = c

func reset():
	pass

func spawn():
	#CatModLoader.cat_mod('Custom Text Indicator', 'spawn()', 'Spawning Custom Text Indicator')
	#('res://Sprites/UI_gfx/marker_sentinel_orb.png') ('res://Sprites/UI_gfx/marker_hating_heart.png')
	var fx_indicator = await ResourceLoader.load('res://FX/text_indicator/text_indicator.tscn') 
	await ResourceLoaderQueue.waitForLoadingFinished()
	spawned_fx_indicator = fx_indicator.instantiate()
	if spawned_fx_indicator == null and not is_instance_valid(spawned_fx_indicator):
		return
	if not CatModLoader.CatModUtils.get_overworld_node():
		Global.World.add_child(spawned_fx_indicator)
	else:
		CatModLoader.CatModUtils.get_overworld_node().add_child(spawned_fx_indicator)
	spawned_fx_indicator_text_node = spawned_fx_indicator.get_node('Container/Label')
	spawned_fx_indicator_icon_node = spawned_fx_indicator.get_node('Container/Icon')
	if default_text != '' and use_animated_text == false:
		spawned_fx_indicator_text_node.text = default_text
	elif default_text != '' and use_animated_text == true:
		spawned_fx_indicator_text_node.text = ''
		text = default_text
	else:
		spawned_fx_indicator_text_node.text = ''
	spawned_fx_indicator_icon_node.set_texture(icon)
	spawned_fx_indicator.scale = custom_scale
	spawned_fx_indicator.Lifetime = lifetime
	spawned_fx_indicator.play()

func _ready():
	pass

func _process(delta):
	timer += delta
	if not is_instance_valid(spawned_fx_indicator):
		return
	if not timer < max_time:
		if use_animated_text:
			var animated_text : Array = []
			animated_text.append_array(text.split())
			#animated_text.append_array(loader_version)
			#CatModLoader.cat_mod(mod, 'animated text size', animated_text.size())
			if selected_text >= animated_text.size():
				pass
			elif selected_text < animated_text.size():
				max_time = 0.15
				set_text(spawned_fx_indicator_text_node.text + animated_text[selected_text])
				selected_text += 1
	#var pos = CatModLoader.get_player_pos()
	#if pos:
	#	pos.y += -60
	#else:
	#	pos = Vector2.ZERO
	#set_pos(pos)
			#for txt in loader_version:
			#	if txt not in custom_text:
			#		custom_text.append(txt)
			#		set_text(''.join(custom_text))
			#		max_time = 0.15
			#		break
		timer = 0.0
			#CatModLoader.cat_mod(mod, 'loader txt', ''.join(loader_version))
			#CatModLoader.cat_mod(mod, 'loader txt', spawned_fx_indicator_text_node.text)
			#CatModLoader.cat_mod(mod, 'text', custom_text)
			#if selected_text >= custom_text.size():
			#	text_finished = true
			#if not text_finished:
			#	max_time = 0.15
			#	set_text(spawned_fx_indicator_text_node.text + custom_text[selected_text])
			#	selected_text += 1
			#else:
			#	if len(spawned_fx_indicator_text_node.text) != 0:
			#		max_time = 0.25 #(0.70 / text.size()) * 2
			#		CatModLoader.cat_mod(mod, 'max time', max_time)
			#		custom_text.pop_back()
			#		selected_text = custom_text.size() - 1
			#		text_finished = false
			#		#set_text(custom_text[selected_text])
			#if len(spawned_fx_indicator_text_node.text) == 0: 
			#	set_text('')
			#	selected_text = 0
			#	text_finished = false
		#CatModLoader.cat_mod('FX Indicator', '_process', spawned_fx_indicator)