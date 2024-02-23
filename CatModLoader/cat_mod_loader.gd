extends Control

var mods:Array
var mod_log : String
var mod_folder := "res://mods/" #OS.get_executable_path() + '\\mods\\'
var mods_dir := DirAccess.open(mod_folder)
var mods_loaded : bool = false
#const mod = "res://addons/debug_mode/debug_mode.gd"



# we load and instantiate the new scene manually, according to
# https://docs.godotengine.org/en/latest/tutorials/scripting/singletons_autoload.html#custom-scene-switcher
# so that we have a little more control over it than using change_scene...

func toggle_autoplayer(value: bool):
	ProjectSettings.set_setting("halls_of_torment/development/enable_autoplayer", value)
	var setting = ProjectSettings.get_setting("halls_of_torment/development/enable_autoplayer")
	print('ENABLE_AUTOPLAYER: ', setting)
	
func get_all_mods():
	if mods_dir:
		mods_dir.list_dir_begin()
		var file = mods_dir.get_next()
		while file != "":
			mods.append(file)
			file = mods_dir.get_next()
	if not mods_dir:
		DirAccess.make_dir_absolute(mod_folder)
	
func load_mod(mod_path):
	var mod = mods[0]
	print(mod_folder + mod)
	var mod_script = ResourceLoader.load(mod_folder + mod)
	if mod_script:
		mod_log = ("Mod Loaded: " + mod_folder + mod)
		add_child(mod_script.new())
	
func _ready():
	get_all_mods()
	toggle_autoplayer(true)
	load_mod(false)
	
func _process(delta):
	#await get_tree().create_timer(3, true).timeout
	if mods_loaded == false:
		print(mod_log)
		#if GameState.CurrentState == GameState.States.Overworld:
			#mods_loaded = true
	
#func load_mods():
#	var project_path = OS.get_executable_path()
#	print(str(project_path))
