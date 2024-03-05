extends Control

var mod = 'Boss Rush'
var ver = '0.0.1'

var fxs = []
var fx_timer = 0.0

var boss_rush = false
var difficultys = ['easy', 'normal', 'hard', 'expert', 'pro', 'insane', 'random']
var current_difficulty = difficultys[0]
var timer = 0.0
var spawner = 0
var wave_timer = 0.0
var total_spawner_time = 0.0
var waves = []
var bosses = []
var current_wave = 0
var bosses_spawned = 0

var input_timer = 0.0

func reset_input_cooldown():
    input_timer = 0.0

func spawner_on_cooldown(seconds) -> bool:
    return spawner < seconds

func input_on_cooldown(seconds) -> bool:
    return input_timer < seconds

func spawner_reset_cooldown():
    spawner = 0.0

func reset_wave_cooldown():
    wave_timer = 0.0

func create_wave(custom):
    var wave = []
    if not custom:
        return

func get_difficulty():
    return current_difficulty

func set_difficulty(diff):
    if not diff:
        return
    var count = 0
    for difficulty in difficultys:
        if difficulty == diff:
            current_difficulty = difficultys[count]
        count += 1

func create_random_wave():
    var bosses = []
    var wave_length = CatModLoader.get_random_number(10, 20)
    var wave_spawn_timer = CatModLoader.get_random_number(5, 10)
    var boss_1 = CatModLoader.get_boss()
    var boss_2 = CatModLoader.get_boss()
    var boss_3 = CatModLoader.get_boss()
    var boss_4 = CatModLoader.get_boss()
    var boss_5 = CatModLoader.get_boss()
    if current_difficulty == 'easy':
        bosses = [boss_1]
    elif current_difficulty == 'insane':
        bosses = [boss_1, boss_2, boss_3, boss_4, boss_5]
    var wave = [wave_length, wave_spawn_timer, bosses]
    if wave:
        waves.append(wave)

func create_waves():
    var wave_1 = [60, 20, [CatModLoader.get_boss()]]
    var wave_2 = [180, 15, [CatModLoader.get_boss(), CatModLoader.get_boss(), CatModLoader.get_boss(), CatModLoader.get_boss()]]
    var all_waves = [wave_1, wave_2]
    waves = all_waves

func get_wave(search):
    pass

func get_xp_reward():
    return (50 * CatModLoader.get_player_level() * bosses_spawned) / current_wave

func reset():
    boss_rush = false
    timer = 0.0
    spawner = 0
    wave_timer = 0.0
    total_spawner_time = 0.0
    waves = []
    current_wave = 0
    bosses_spawned = 0

func _ready():
    CatModLoader.cat_mod(mod, 'Mod has been loaded!', 'Current Version', ver)
    create_random_wave()

func _process(_delta):
    input_timer += _delta
    var state = CatModLoader.get_current_game_state_id()

    if state == GameState.States.PlayerDied or state == GameState.States.PlayerSurvived:
        if boss_rush == true:
            reset()

    if state != GameState.States.InGame:
        return

    if boss_rush == false:
        CatModLoader.cat_mod(mod, '_process', 'Creating new random wave!', ver)
        create_random_wave()
        boss_rush = true

    if Input.is_key_pressed(KEY_TAB) and not Input.is_key_pressed(KEY_CTRL) and not input_on_cooldown(1):
        CatModLoader.cat_mod(mod, 'Wave Timer', wave_timer)
        CatModLoader.cat_mod(mod, 'Current Wave', len(waves))
        CatModLoader.cat_mod(mod, 'Bosses Spawned', bosses_spawned)
        CatModLoader.cat_mod(mod, 'Next XP Reward', get_xp_reward(), false)
        CatModLoader.cat_mod(mod, 'Difficulty', current_difficulty)
        CatModLoader.cat_mod(mod, 'Wave Info', waves[current_wave])
        input_timer = 0.0

    if Input.is_key_pressed(KEY_TAB) and Input.is_key_pressed(KEY_CTRL) and not input_on_cooldown(0.5):
        var fx = await CatModLoader.spawn("res://GameElements/Summons/HoundSummon.tscn", true, false)
        var summon = await CatModLoader.spawn("res://GameElements/Town_Portal.tscn", true, false)
        var test = await CatModLoader.spawn("res://GameElements/TestSummon.tscn", true, false)
        if fx:
            CatModLoader.cat_mod(mod, 'Spawn FX', fx)
        #set_difficulty('insane')
        input_timer = 0.0


    if boss_rush == true:
        timer += _delta
        fx_timer += _delta
        spawner += _delta
        wave_timer += _delta
        if not fx_timer < 0.25:
            var fx = await CatModLoader.spawn("res://FX/ground_hit/ground_hit_purple.tscn", true, false) # "res://FX/area_telegraph/area_telegraph.tscn" "res://FX/hound/hound_attack.tscn"
            if fx:
                fxs.append(fx)
                #CatModLoader.cat_log('FXS', fxs)
                #CatModLoader.cat_log('FX Node', fx)
                #CatModLoader.cat_log('FX Node', len(fxs))
                if fxs.size() > 5:
                    if is_instance_valid(fx):
                        fxs[0].queue_free()
                    fxs.remove_at(0)
                #fx.queue_free()
            fx_timer = 0.0
        if not timer < 1:
            var hud = GlobalMenus.hud
            if hud:
                CatModLoader.cat_mod(mod, 'HUD', hud)
                hud.get_node(hud.GoldLabel).text = str('Wave: ' + str(waves.size() - 1))
            if wave_timer >= waves[current_wave][0]:
                CatModLoader.cat_mod(mod, 'Wave Timer', wave_timer)
                CatModLoader.cat_mod(mod, 'Current Wave', len(waves))
                CatModLoader.cat_mod(mod, 'Bosses Spawned', bosses_spawned)
                var player_pos = CatModLoader.get_player_pos()
                if current_wave != 0:
                    CatModLoader.cat_mod(mod, 'Wave Survived: XP Earned', get_xp_reward())
                    CatModLoader.add_player_xp(get_xp_reward(), false)
                    CatModLoader.collect_all_xp()
                    await CatModLoader.spawn("res://FX/twinkle_flash.tscn")
                    await CatModLoader.spawn("res://FX/revive/revive_effect.tscn")
                create_random_wave()
                current_wave += 1
                wave_timer = 0.0
            if spawner >= waves[current_wave][1]:
                CatModLoader.cat_mod(mod, 'Spawn Cooldown', waves[current_wave][1])
                var boss = waves[current_wave][2].pick_random()
                #var random_boss = CatModLoader.get_boss()
                CatModLoader.cat_mod(mod, 'Boss', boss)
                var spawned_boss = await CatModLoader.spawn(boss, false, true)
                if is_instance_valid(spawned_boss):
                    CatModLoader.cat_mod(mod, 'Spawned Boss', spawned_boss)
                spawner = 0.0
                bosses_spawned += 1
            timer = 0.0
            wave_timer += 1