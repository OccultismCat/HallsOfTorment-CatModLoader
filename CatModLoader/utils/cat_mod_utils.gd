extends Node

var mod = 'CatModUtils'
var ver = '0.0.1'

var mod_loaded = false
var timer = 0.0
var count = 0

var scene_root = null
var overworld = null
var player_selected = null

var spawned_custom_text_indicators : Array

## Basic Functions ##
func get_overworld_node():
	if not Global:
		return
	var scene_root = Global.get_parent()
	if not scene_root.has_node('Overworld'):
		return
	return scene_root.get_node('Overworld')

## Custom Functions ## ## TODO FIX ARGS ORDER ##
func spawn_custom_text_indicator(custom_text=null, custom_lifetime=null, animated_text=false, scale=null, icon_texture=null, add_to_array=false):
	var custom_text_indicator = await CatModLoader.load_mod('res://CatModLoader/scripts/', 'custom_text_indicator.gd', false)
	add_child(custom_text_indicator)
	if custom_text != null:
		custom_text_indicator.default_text = custom_text
	if animated_text != false:
		custom_text_indicator.use_animated_text = true
	if custom_lifetime != null:
		custom_text_indicator.lifetime = custom_lifetime
	if scale != null:
		custom_text_indicator.custom_scale = (Vector2.ONE * scale)
	if icon_texture != null:
		if typeof(icon_texture) == TYPE_STRING:
			var texture = await ResourceLoaderQueue.getCachedResource(icon_texture)
			if texture:
				custom_text_indicator.icon = texture
	custom_text_indicator.spawn()
	if add_to_array != false:
		spawned_custom_text_indicators.append(custom_text_indicator)
		#CatModLoader.cat_mod(mod, 'Array', spawned_custom_text_indicators)
	return custom_text_indicator

func spawn_enemy():
	pass

func spawn_boss():
	pass

func _ready():
	pass
	#if not Global.get_parent().has_node('Overworld'):
	#	return
	#spawn_custom_text_indicator()
	#scene_root.connect('PlayerCharacterSelected', func():
	#	CatModLoader.cat_mod(mod, 'connect', scene_root))
	#overworld = ResourceLoaderQueue.getCachedResource("res://Environments/OverWorld/Overworld.gd").new()

func _process(delta):
	timer += delta
	if not timer < 4:
		timer = 0.0
		#count = 0
		#scene_root = Global.ChosenPlayerCharacterScene
		#CatModLoader.cat_mod(mod, 'scene root', Global.World)
		#if scene_root:
		#	scene_root = scene_root.get_state()
		#CatModLoader.cat_mod(mod, 'scene root', scene_root)
		#while count < scene_root.get_node_count():
		#	var node_path = scene_root.get_node_path(count)
		#	CatModLoader.cat_mod(mod, 'scene root', node_path)
		#	count += 1
		#CatModLoader.cat_mod(mod, 'scene root', Global.getChildNodeWithMethod("ChosenPlayerCharacterScene"))
		
		#CatModLoader.cat_mod(mod, 'scene root', scene_root.global_position)
		#CatModLoader.cat_mod(mod, 'Info', scene_root.current_player_character)
		#spawn_custom_text_indicator()
		#CatModLoader.cat_mod(mod, 'Info', Global.World)
		#CatModLoader.cat_mod(mod, 'Info', Global.WorldsPool)
		#var char_selected = Global.ChosenPlayerCharacterScene
		#var char_selected_state = char_selected.get_state()
		#var char_selected_ident = Global.ChosenPlayerCharacterIdentifier
		#CatModLoader.cat_mod(mod, 'Character Selected', char_selected)
		#CatModLoader.cat_mod(mod, 'Character Selected', char_selected_state.get_node_count())
		#CatModLoader.cat_mod(mod, 'Character Selected Ident', char_selected_ident)
	#if not mod_loaded:
	#	spawn_custom_text_indicator()
	#	mod_loaded = true