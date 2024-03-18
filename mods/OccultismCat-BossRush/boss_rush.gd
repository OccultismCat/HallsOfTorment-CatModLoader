extends Control

var mod = 'Boss Rush'
var ver = '0.0.3'

var fxs = []
var fx_timer = 0.0
var fx_text_timer = 0.0

var boss_rush = true
var start = true
var difficultys = ['easy', 'normal', 'hard', 'expert', 'pro', 'insane', 'random']
var current_difficulty_index = 0
var current_difficulty = difficultys[current_difficulty_index]
var player_level = 0
var timer = 0.0
var spawner = 0
var wave_timer = 0.0
var total_spawner_time = 0.0
var waves = []
var bosses = []
var current_wave = 0
var bosses_spawned = 0
var max_boss_spawns = (2 * current_wave)

var waves_survived_node = null
var selected_color = 0

var hud_timer = 0.0

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

func set_difficulty(diff=null):
    if not diff:
        return
    var count = 0
    current_difficulty = difficultys[diff]
    if diff != null:
        if typeof(diff) == TYPE_STRING:
            for difficulty in difficultys:
                if difficulty == diff:
                    current_difficulty_index = count
                    current_difficulty = difficultys[current_difficulty_index]
                count += 1

func create_random_wave():
    var difficulty = get_difficulty()
    var bosses = []
    var wave_min = 0
    var wave_max = 0
    var spawn_rate_min = 0
    var spawn_rate_max = 0
    if difficulty == 'easy':
        wave_min = 30
        wave_max = 120
        spawn_rate_min = 8
        spawn_rate_max = 20
    elif difficulty == 'insane':
        wave_min = 60
        wave_max = 120
        spawn_rate_min = 5
        spawn_rate_max = 10
    var wave_length = CatModLoader.get_random_number(wave_min, wave_max)
    var wave_spawn_timer = CatModLoader.get_random_number(spawn_rate_min, spawn_rate_max)
    var wave = [wave_length, wave_spawn_timer, bosses]
    if wave:
        waves.append(wave)

func get_wave(search):
    pass

func get_xp_reward():
    return (50 * CatModLoader.get_player_level() * bosses_spawned) / current_wave

func reset():
    boss_rush = true
    #timer = 0.0
    #spawner = 0
    #wave_timer = 0.0
    #total_spawner_time = 0.0
    waves = []
    #current_wave = 0
    #bosses_spawned = 0

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta):
    input_timer += _delta
    var state = CatModLoader.get_current_game_state_id()

    if state == GameState.States.PlayerDied or state == GameState.States.PlayerSurvived:
        if boss_rush == true:
            timer = 0.0
            spawner = 0
            wave_timer = 0.0
            total_spawner_time = 0.0
            waves = []
            current_wave = 0
            bosses_spawned = 0

    if state != GameState.States.InGame:
        return

    if start == true:
        reset()
        create_random_wave()
        start = false
    
    if Input.is_key_pressed(KEY_TAB) and not Input.is_key_pressed(KEY_CTRL) and not input_on_cooldown(1):
        if boss_rush == false:
            boss_rush = true
        elif boss_rush == true:
            boss_rush = false
        CatModLoader.cat_mod(mod, 'Enabled', boss_rush)
        input_timer = 0.0

    if Input.is_key_pressed(KEY_TAB) and Input.is_key_pressed(KEY_CTRL) and not input_on_cooldown(0.5):
        current_difficulty_index += 1
        if current_difficulty_index >= difficultys.size():
            current_difficulty_index = 0
        current_difficulty = difficultys[current_difficulty_index]
        CatModLoader.cat_mod(mod, 'Current Difficulty', current_difficulty)
        #CatModLoader.cat_mod(mod, 'Difficulty INDEX', current_difficulty_index)
        #var fx = await CatModLoader.spawn("res://GameElements/Summons/HoundSummon.tscn", true, false)
        input_timer = 0.0

    if hud_timer < 0.01:
        var hud = GlobalMenus.hud
        if hud:
            var spawn_timer = str(waves[current_wave][1] - int(spawner))
            var waves_amount = str(waves.size())
            var boss_rush_hud = "[W:" + waves_amount + '][S:' + spawn_timer + ']'
            hud.get_node(hud.GoldLabel).text = boss_rush_hud
        hud_timer = 0.0

    if boss_rush == true:
        timer += _delta
        fx_timer += _delta
        spawner += _delta
        wave_timer += _delta
        fx_text_timer += _delta
        var random_fx_wait = CatModLoader.get_random_number(5, 10)
        var colors = [Color(1, 0, 0, 1), Color(0, 1, 0, 1), Color(0, 0, 1, 1), Color(1, 1, 0, 1), Color(0, 1, 1, 1)]
        if waves_survived_node and is_instance_valid(waves_survived_node):
            var pos = CatModLoader.get_player_pos()
            pos.y += 20
            waves_survived_node.global_position = pos

        if not fx_timer < random_fx_wait:
            CatModLoader.spawn_text_fx('', 'res://.godot/imported/h_mark_of_madness.png-1139fa4cdb60889165250e02cd28f490.s3tc.ctex', 0.01, 1, false, true, Color(1,1,1,1), Color(1,0,0,0.8))
            fx_timer = 0.0
        if not fx_text_timer < 0.20:
            if waves_survived_node and is_instance_valid(waves_survived_node):
                #CatModLoader.cat_mod(mod, 'Found wave survived node', waves_survived_node)
                #CatModLoader.cat_mod(mod, 'Selected Color', selected_color)
                var text_label = waves_survived_node.get_node('Container/Label')
                colors.shuffle()
                if colors.size() <= selected_color:
                    selected_color = 0
                text_label.modulate = colors[selected_color]
                selected_color += 1
            fx_text_timer = 0.0
        if not timer < 1:
            if wave_timer >= waves[current_wave][0]:
                CatModLoader.cat_mod(mod, 'Wave Timer', wave_timer)
                CatModLoader.cat_mod(mod, 'Current Wave', len(waves))
                CatModLoader.cat_mod(mod, 'Bosses Spawned', bosses_spawned)
                var player_pos = CatModLoader.get_player_pos()
                if current_wave != 0:
                    #CatModLoader.spawn_text_fx(' Wave Survived! [' + str(len(waves)) + ']', 'res://.godot/imported/mrk_sanctity.png-1de563471c0e7a8b71d03d64480601e9.ctex', 0.5, 2.5, false, true, Color(0, 1, 0, 0.8), Color(1, 0, 0, 1))
                    #CatModLoader.spawn_fx('res:///FX/text_indicator/text_indicator.tscn')
                    waves_survived_node = await CatModLoader.spawn_fx_indicator('Wave Survived!')
                    CatModLoader.cat_mod(mod, 'Wave Survived FX', waves_survived_node)
                    CatModLoader.cat_mod(mod, 'Wave Survived: XP Earned', get_xp_reward())
                    CatModLoader.add_player_xp(get_xp_reward(), false)
                    CatModLoader.collect_all_xp()
                    var revive_effect = await ResourceLoaderQueue.getCachedResource("res://FX/revive/revive_effect.tscn")
                    await ResourceLoaderQueue.waitForLoadingFinished()
                    var spawned_revive_effect = await CatModLoader.spawn(revive_effect, false, false, true)
                    spawned_revive_effect.process_mode = 0
                    CatModLoader.cat_mod(mod, 'Revive Effect Node', spawned_revive_effect.process_mode)
                create_random_wave()
                current_wave += 1
                max_boss_spawns += 2
                wave_timer = 0.0
            if spawner >= waves[current_wave][1]:
                CatModLoader.cat_mod(mod, 'Wave Timer', wave_timer)
                CatModLoader.cat_mod(mod, 'Current Wave', len(waves))
                CatModLoader.cat_mod(mod, 'Bosses Spawned', bosses_spawned)
                if bosses_spawned >= max_boss_spawns:
                    player_level = CatModLoader.get_player_level()
                    CatModLoader.cat_debug(mod, 'Level', player_level)
                    if player_level >= bosses_spawned:
                        CatModLoader.cat_mod(mod, 'Increasing Max Boss Spawns', max_boss_spawns + 1)
                        max_boss_spawns += 1
                if bosses_spawned < max_boss_spawns:
                    var boss = CatModLoader.get_boss()
                    var spawned_boss = await CatModLoader.spawn(boss, false, true, false)
                    if is_instance_valid(spawned_boss):
                        CatModLoader.cat_mod(mod, 'Spawned Boss', spawned_boss, spawned_boss.get('name'))
                        bosses_spawned += 1
                    var player_pos = CatModLoader.get_player_pos()
                    player_pos.y += -60
                    CatModLoader.spawn_text_fx(' +1', 'res://.godot/imported/mrk_beast.png-da005c6f926eabc33c1def50e6551d14.ctex', 0.8, 3.5, false, false, Color(1, 0, 0, 0.8), Color(1, 0, 0, 1), player_pos)
                var enemys = CatModLoader.get_random_enemys(4)
                for enemy in enemys:
                    var spawned_enemy = await CatModLoader.spawn(enemy, false, true, false)
                    if is_instance_valid(spawned_enemy):
                        CatModLoader.cat_mod(mod, 'Spawned Enemy', spawned_enemy, spawned_enemy.get('name'))
                var player_pos = CatModLoader.get_player_pos()
                player_pos.y += 60
                CatModLoader.spawn_text_fx(' +' + str(enemys.size()) + '', 'res://.godot/imported/mrk_rituals.png-8b20dc4fd75a81fe567c8ce905971355.ctex', 0.8, 3.5, false, false, Color(1, 0, 0, 0.8), Color(1, 0, 0, 1), player_pos)

                CatModLoader.cat_mod(mod, 'Spawn Cooldown', waves[current_wave][1])
                CatModLoader.cat_mod(mod, 'Spawned Bosses', str(bosses_spawned) + '/' + str(max_boss_spawns))
                spawner = 0.0
                
            timer = 0.0
            wave_timer += 1