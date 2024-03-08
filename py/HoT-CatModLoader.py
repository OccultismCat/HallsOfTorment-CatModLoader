import os, sys, time, json, psutil, threading, subprocess
from colorama import Fore, init
init()

game_log = f"{os.getenv('APPDATA')}\\HallsOfTorment\\logs\\godot.log"
game_logs = []

current_path = os.path.dirname(os.path.realpath(__file__)) + '\\'

version = '0.1.2'

pack_files = {
    'default': {
        'file':'HallsOfTorment.pck',
        'exe':'HallsOfTorment.exe'
    },
    'modded': {
        'file':'HoT-CatModLoader.pck',
        'exe':'HallsOfTorment.exe',
    },
    'extracted': {
        'file':None,
        'exe':'HallsOfTorment.exe'
    }
}

def get_current_path():
    global current_path
    current_path = current_path.replace("\\\\", "\\")
    return current_path

def get_path(path):
    if path:
        return f"{path}".replace('\\\\', '\\')

def splash():
    return '''=========+=+**++#*==========================++#%%%*+
========+*=++*+++#*========================+%%%%%%%*
=========+==+++++***++**+================+##%%%%%%%*
=========*##*##*#**#*******+++*+*++++==*#####%####%*
=========**##########**#######################**+#%*
========+**################################**++*+#%*
========+#################################*+***+*%%+
========+###*+=--++#########################*++#%%++
========*####-::::+###############*##########*##%*++
=======+**###+-::=*###########*-::=*#############+++
=======***###################*-::::+#############+++
======+*###############*#######---=##########%##++++
======*#*##########*#########################%%*++=+
=====+***###################################%%%+++=+
=====+**#####################################%%++++=
====+*#*##**################################%%%*+==+
=====*#####*##%%-######+*###############%%###%%*+=+=
====*#######%%%%+#-###*:*######*########%%%%#%#++==+
====+*%%####%#%#+=-###==#%%%%###*######%%%%%%%#+++++
=====*########*#-:=###+-%###%%%########%%%%%%#++=+++
====+*########++---*#+=+*=+%%%%%%######%%%%%%#+=====
=====*########*----++-=#***++%%%%#####**#%%%#+======
=====+########**==*#**+##++##%#%%%%#**++*#%#+=======
-----=+######****++***+==#######%%#*+++++**+=---====
-----=+*#######*#*############%%%*++++++++===-----==
----=+***##%%###**###*####%%%##**++=========--------
----=+############*#*########***+++=========--------
---=*###########*######**####**++++++=======--------'''

def log(text, type=None, var=None, newline=False, color=None, step=None):
    global version
    if not var:
        var = ''
    print_text = ''
    title = Fore.YELLOW + ' |' + Fore.LIGHTRED_EX + ' [CatModLoader] ' + Fore.YELLOW + '|' + Fore.GREEN + f' [V-{version}] ' + Fore.RESET
    log_start = Fore.YELLOW + '[CatModLoader]: ' + Fore.RESET
    if type == 'title':
        if newline == True:
            print_text += '\n'
        print_text = f'{str(text)}{title}{var}'
        print(print_text)
    elif type == 'setup' or type == 's':
        print_text = log_start + Fore.LIGHTGREEN_EX + '[SETUP] | ' + Fore.RESET
        if step != None:
            print_text += Fore.LIGHTGREEN_EX + f'[STEP]: {step}. | ' + Fore.RESET
        print_text += str(text)
        print(print_text)
    elif type == 'text':
        print(Fore.LIGHTWHITE_EX + str(text) + Fore.RESET)
    elif type == 'menu':
        if newline == True:
            print_text = '\n'
        if not color:
            color = Fore.YELLOW
        print_text += color + str(text) + Fore.RESET
        if var:
            print_text += Fore.GREEN + f': {var}' + Fore.RESET
        print(print_text)
    elif type == 'menu-back':
        if newline == True:
            print_text = '\n' + Fore.YELLOW + '[0] - ' + Fore.LIGHTRED_EX + f'{text}' + Fore.RESET
        else:
            print_text = Fore.YELLOW + '[0] - ' + Fore.LIGHTRED_EX + f'{text}' + Fore.RESET
        print(print_text)
    elif type == 'error' or type == 'e':
        print(log_start + Fore.RED + '[ERROR] | ' + str(text) + '\n' + Fore.RESET)
    elif type == 'debug' or type == 'd':
        print(log_start + Fore.MAGENTA + '[DEBUG] ' + Fore.LIGHTCYAN_EX + str(text) + '\n' + Fore.RESET)
    elif type == 'mod' or type == 'm':
        print_text = ''
        print(f"{log_start}" + Fore.LIGHTGREEN_EX + "[MOD] " + Fore.LIGHTWHITE_EX + str(text) + Fore.RESET)
    else:
        print(log_start + Fore.LIGHTWHITE_EX + str(text) + Fore.RESET)

def wait(wait_time=0):
    if wait_time == 0:
        os.system('pause')
    else:
        time.sleep(int(wait_time))

def clear():
    os.system('cls')

def set_console_size(cols, lines):
    try:
        pass
        #os.system(f'mode con: cols={cols} lines={lines}')
    except Exception as error:
        print(str(error))

def splash_screen():
    set_console_size(55, 27)
    os.system('cls')
    print(Fore.RED + splash() + Fore.RESET)
    time.sleep(1)
    os.system('cls')
    set_console_size(90, 10)

## Settings Functions ##
def create_settings():
    settings_data = {
        "launcher_settings": {
            'paths': {
                'game': {
                    'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment",
                    'custom': ''
                },
                'tools': {
                    'gdre': {
                        'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment\\Tools",
                        'custom': ''
                    },
                    'pck_explorer': {
                        'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment\\Tools",
                        'custom': ''
                    }
                },
                'game_extracted': {
                    'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment\\Extracted"
                }
            },
            "autostart_enabled": False,
            "autostart_timer": 2,
            "autostart": 0
        },
        'game_settings': {
            'verbose': False,
            'debug': False
        }
    }
    with open('settings.json', 'w') as file:
        json.dump(settings_data, file, indent=4)

def save_settings(settings):
    if not settings:
        return
    with open('settings.json', 'w+') as file:
        json.dump(settings, file, indent=4)

def load_settings():
    if not os.path.exists('settings.json'):
        create_settings()
    try:
        with open('settings.json', 'r') as file:
            settings = json.load(file)
            return settings
    except Exception as error:
        log(error, 'e')

## Game Settings Functions ##
def get_game_setting(search):
    if not search:
        return
    settings = load_settings()
    try:
        return settings['game_settings'][search]
    except Exception as error:
        log(error, 'e')

## Launcher Settings Functions ##
def get_launcher_setting(search, search_2=None, search_3=None, search_4=None):
    if not search:
        return
    settings = load_settings()
    if search_4:
        try:
            return settings['launcher_settings'][search][search_2][search_3][search_4]
        except Exception as error:
            log(error, 'e')
    if search_3:
        try:
            return settings['launcher_settings'][search][search_2][search_3]
        except Exception as error:
            log(error, 'e')
    elif search_2:
        try:
            return settings['launcher_settings'][search][search_2]
        except Exception as error:
            log(error, 'e')
    elif search:
        try:
            return settings['launcher_settings'][search]
        except Exception as error:
            log(error, 'e')

def set_launcher_setting(setting, value):
    settings = load_settings()
    if not settings:
        return
    try:
        settings['launcher_settings'][setting] = value
    except Exception as error:
        log(error, 'e')
    save_settings(settings)

def toggle_launcher_setting(setting):
    settings = load_settings()
    if not setting:
        return
    try:
        setting_value = settings['launcher_settings'][setting]
    except Exception as error:
        log(error, 'e')
    if setting_value == False:
        set_launcher_setting(setting, True)
    elif setting_value == True:
        set_launcher_setting(setting, False)

## Pack File Functions ##
def get_pack_file(search=None):
    if search:
        for file in pack_files:
            if file == search:
                try:
                    pack_file = pack_files[search]
                    return pack_file
                except Exception as error:
                    log(error, 'e')
    pack_file = pack_files['modded']['file']
    if not os.path.exists(pack_files['modded']['file']):
        pack_file = pack_files['default']['file']
    return pack_file

def get_pack_file_option(search, option_search):
    if not option_search:
        return
    if type(search) == str:
        pack_file = get_pack_file(search)
    else:
        pack_file = search
    if pack_file:
        try:
            option = pack_file[option_search]
            return option
        except Exception as error:
            log(error, 'e')
    wait()

def create_launch_game_command(pack_file):
    if not pack_file:
        return
    commands = ['start', 'cmd.exe', '/K']
    exe = get_pack_file_option(pack_file, 'exe')
    if exe:
        commands.append(exe)
    if get_game_setting('verbose') == True:
        commands.append('--verbose')
    if get_game_setting('debug') == True:
        commands.append('--debug')
    pack = get_pack_file_option(pack_file, 'file')
    if pack:
        commands.append('--main-pack')
        commands.append(pack)
    return commands

## Game Functions ##
def find_process(search):
    found_process = None
    if not search:
        return
    try:
        for process in psutil.process_iter(['pid', 'name', 'ppid']):
            if process.info['name'] == search:
                found_process = process
                log(process, 'd')
    except Exception as error:
        log(error, 'e')
    child_processes = get_child_processes(found_process.info['ppid'])
    log(child_processes, 'd')

def get_game_processes():
    try:
        for process in psutil.process_iter(['pid', 'name', 'ppid']):
            if process.info['name'] == 'conhost.exe':
                process_children = get_child_processes(process.info['ppid'])
                for child in process_children:
                    if child['name'] == 'HallsOfTorment.exe':
                        return process_children
    except Exception as error:
        log(error, 'e')

def get_child_processes(parent_pid):
    child_processes = []
    for process in psutil.process_iter(['pid', 'name', 'ppid']):
        if process.info['ppid'] == parent_pid:
            child_pid = process.info['pid']
            child_name = process.info['name']
            child_processes.append({'pid': child_pid, 'name': child_name})
            child_processes.extend(get_child_processes(child_pid))
    return child_processes

def exit_processes(processes):
    if not processes:
        return
    for process in processes:
        try:
            psutil.Process(process['pid']).terminate()
        except Exception as error:
            pass #log(error, 'e')

def clear_log():
    global game_logs
    game_logs = []
    with open(game_log, 'w+') as file:
        file.write('')

def get_log(file_size):
    with open(game_log, 'r') as file:
        file.seek(file_size)
        new_lines = file.readlines()
        for line in new_lines:
            if "[CatModLoader]" in line:
                log(line.strip().replace('[CatModLoader] | ', ''), 'mod')
                game_logs.append(line.strip())
            elif "SCRIPT ERROR:" in line:
                log(line.strip(), 'e')
            elif "could not be loaded!" in line:
                log(line.strip(), 'e')

def watch_game():
    global game_logs
    clear_log()
    file_size = 0
    processes = None
    log('[Launch Game]', 'title', newline=True)
    while True:
        if is_running('HallsOfTorment.exe'):
            if not processes or processes == []:
                processes = get_game_processes()
            current_size = os.path.getsize(game_log)
            if current_size > file_size:
                get_log(file_size)
                file_size = current_size
                
            time.sleep(0.1)
        else:
            exit_processes(processes)
            break

def watch_game_thread():
    while True:
        if is_running('HallsOfTorment.exe'):
            break
        time.sleep(0.01)
    try:
        thread = threading.Thread(target=watch_game)
        thread.start()
    except Exception as error:
        pass #log(error, 'e')

def is_running(process_name):
    for process in psutil.process_iter(['pid', 'name']):
        if process.info['name'] == process_name:
            return True
    return False

def launch_game(commands):
    log(commands, 'd')
    if not os.path.exists(commands[3]):
        log(f"Couldn't find {commands[3]}!", 'e')
        time.sleep(3)
        return
    try:
        os.system(' '.join(commands))
    except Exception as error:
        print(str(error))
    watch_game_thread()

## Global Menu Functions ##
def go_back(user_input):
    if user_input == '0' or user_input == 'e' or user_input == 'E':
        return True

def confirm(text):
    user_input = input('\n' + str(text))
    if user_input == 'Y' or user_input == 'y' or user_input == '1':
        return True
    else:
        return False

## Launch Settings Menu ## !Update to new menu method!
def menu_launch_settings():
    while True:
        os.system('cls')
        options = [
            ['Auto Start Game', str(get_launcher_setting('autostart_enabled'))]
        ]
        log('[Launch Settings]', 'title', newline=True)
        for index, option in enumerate(options):
            log(f'[{(index + 1)}] - {option[0]}', 'menu', option[1])
        log('Go Back', 'menu-back', newline=True)
        user_input = input('\nOption: ')
        if user_input == '0' or user_input == 'e':
            return
        elif user_input == '1':
            toggle_launcher_setting('autostart_enabled')

## Functions Fucntions (ha) ##
def extract_pack_file():
    game_path = get_launcher_setting('paths', 'game', 'default')
    gdre_tool = f'"{get_launcher_setting('paths', 'tools', 'gdre', 'default')}\\gdre_tools.exe"'
    pack_file = f'"{game_path}' + '\\HallsOfTorment.pck"'
    extract_path = f'"{get_launcher_setting('paths', 'game_extracted', 'default')}"'
    commands = [gdre_tool, '--headless', '--verbose', f'--recover={pack_file}', f'--output-dir={extract_path}']
    command = f'{gdre_tool} --headless --verbose --recover={pack_file} --output-dir={extract_path}'
    log(command, 'd')
    set_console_size(150, 30)
    wait()
    try:
        print(Fore.YELLOW)
        subprocess.run(' '.join(commands))
        print(Fore.RESET)
        wait()
    except Exception as error:
        log(error, 'e')
    except KeyboardInterrupt:
        wait()

def add_modloader_to_game():
    project_file = get_launcher_setting('paths', 'game_extracted', 'default') + '\\project.godot'
    if os.path.exists(project_file):
        with open(project_file, 'r') as file:
            lines = file.readlines()
        try:
            index = lines.index('AutoPlayer="res://Utilities/AutoPlayer.gd"\n')
        except Exception as error:
            log(error, 'e')
        lines.insert(index, 'CatModLoader="*res://CatModLoader/cat_mod_loader.gd"\n')
        with open(project_file, 'w') as file:
            file.writelines(lines)
        #try:
        #    for line in lines:
        #        log(line, 'd')
        #except Exception as error:
        #    log(error, 'e')
            
def create_pack_file():
    pack_explorer_tool = f'"{get_launcher_setting('paths', 'tools', 'pck_explorer', 'default')}\\GoDotPCKExplorer.UI.exe"'
    log(pack_explorer_tool, 'd')
    try:
        os.system(f'{pack_explorer_tool}')
    except Exception as error:
        log(error, 'e')
    wait()
            
def setup_catmodloader():
    while True:
        clear()
        ## Step 1: Make sure the paths are correct. ##
        game_path = get_launcher_setting('paths', 'game', 'default')
        log('[Setup CatModLoader - Paths]', 'title')
        log(f'Set your game path.\n', 's', step='1')
        log(f'[Default]', 's', step='1')
        log(f'{get_path(game_path)}', 's', step='1')
        if not confirm('Use Default?: [Y/N]: '):
            user_input = input('\nEnter Path: ')
        clear()
        game_extracted_path = get_launcher_setting('paths', 'game_extracted', 'default')
        log('[Setup CatModLoader - Paths]', 'title')
        log('Set the path to extract files to.\n ', 's', step='2')
        log('[Default]', 's', step='2')
        log(f'{get_path(game_extracted_path)}', 's', step='2')
        if not confirm('Use Default?: [Y/N]: '):
            user_input = input('\nEnter Path: ')
        clear()
        gdre_path = get_launcher_setting('paths', 'tools', 'gdre', 'default')
        log(game_path, 'd')
        log(game_extracted_path, 'd')
        log(gdre_path, 'd')
        wait()

## Functions Menu ## !Update to new menu method!
def menu_tools_n_setup():
    set_console_size(60, 15)
    options = {
        0: {
            'text': 'Setup CatModLoader',
            'func': setup_catmodloader,
            'newline': False
        },
        1: {
            'text': 'Extract Pack File',
            'func': extract_pack_file,
            'newline' : False
        },
        2: {
            'text': 'Create Pack File',
            'func': create_pack_file,
            'newline': False
        }
    }
    #options = [
    #    ['Extract Pack File', extract_pack_file],
    #    ['Setup CatModLoader', setup_catmodloader]
    #]
    while True:
        clear()
        log('[Tools & Setup Menu]', 'title')
        for index, option in enumerate(options):
            log(f'[{index + 1}] - {options[option]['text']}', 'menu', newline=options[option]['newline'])
        log('Go Back', type='menu-back', newline=True)
        user_input = input('\nOption: ')
        if go_back(user_input):
            break
        user_input = int(user_input) - 1
        try:
            options[user_input]['func'](options[user_input]['args'])
        except Exception as error:
            log(error, 'e')
            try:
                options[user_input]['func']()
            except Exception as error:
                log(error, 'e')

## Main Menu Functions ##
def menu_start_auto(options):
    log('[AutoStart Loading]', 'title')
    log('Use "CTRL+C" to cancel', 'text')
    try:
        time.sleep(get_launcher_setting('autostart_timer'))
    except KeyboardInterrupt:
        os.system('cls')
        return
    try:
        options[get_launcher_setting('autostart')]['func'](options[get_launcher_setting('autostart')]['args'])
    except Exception as error:
        log(error, 'e')
    while True:
        if is_running('HallsOfTorment.exe'):
            time.sleep(0.01)
        else:
            break

def menu_option_launch_game(version):
    set_console_size(60, 10)
    os.system('cls')
    pack_file = get_pack_file(version) 
    get_pack_file_option(version, 'file')
    commands = create_launch_game_command(pack_file)
    launch_game(commands)

def menu_start():
    set_console_size(60, 15)
    # Menu options
    options = {
        0: {
            'text': "Start Modded Game",
            'func': menu_option_launch_game,
            'args': 'modded',
            'newline': False},
        1: {
            'text': "Start Default Game",
            'func': menu_option_launch_game,
            'args': 'default',
            'newline': False},
        2: {
            'text': "Start Extracted Game",
            'func': menu_option_launch_game,
            'args': 'extracted',
            'newline': False},
        3: {
            'text': Fore.LIGHTGREEN_EX + 'Settings' + Fore.RESET,
            'func': menu_launch_settings,
            'newline': True
            },
        4: {
            'text': Fore.CYAN + 'Tools & Setup' + Fore.RESET,
            'func': menu_tools_n_setup,
            'newline': False
        }}
    while True:
        clear()
        if get_launcher_setting('autostart_enabled') == True:
            while True:
                menu_start_auto(options)
        # Print menu
        log('[Launch Menu]', 'title')
        for index, option in enumerate(options):
            log(f'[{index + 1}] - {options[option]['text']}', 'menu', newline=options[option]['newline'])
        log('Go Back', type='menu-back', newline=True)
        # Get user input 
        user_input = input('\nOption: ')
        if user_input == '0' or user_input == 'e' or user_input == 'E':
            return
        log(option, 'd')
        # Set user_input to correct value 
        user_input = int(user_input) - 1
        # Launch game
        try:
            options[user_input]['func'](options[user_input]['args'])
        except Exception as error:
            try:
                options[user_input]['func']()
            except Exception as error:
                log(error, 'e')
        try:
            pass
        except Exception as error:
            log(error, 'e')
        while is_running('HallsOfTorment.exe'):
            time.sleep(0.01)

## Start ##
def start():
    #setup_catmodloader()
    #add_modloader_to_game()
    #wait()
    menu_start()

splash_screen()
start()