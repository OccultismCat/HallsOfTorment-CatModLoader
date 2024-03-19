import os, sys, time, json, psutil, threading, subprocess
from colorama import Fore, init
init()

current_path = os.path.dirname(os.path.realpath(__file__)) + '\\'

version = '0.1.3'

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
    elif type == 'info' or type == 'i':
        print_text = log_start + Fore.LIGHTBLUE_EX + '[INFO] ' + Fore.YELLOW + '| ' + Fore.LIGHTWHITE_EX + str(text) + Fore.RESET
        print(print_text)
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
        print_text = log_start + Fore.LIGHTRED_EX + '[PY-ERROR]' + Fore.LIGHTWHITE_EX + ' | ' + Fore.LIGHTRED_EX + str(text) + Fore.RESET
        if newline == True:
            print_text += '\n'
        print(print_text)
    elif type == 'mod-error' or type == 'me':
        try:
            print_text = log_start + Fore.LIGHTRED_EX + '[MOD-ERROR]' + Fore.LIGHTWHITE_EX + ' | ' + Fore.LIGHTRED_EX + str(text).replace('USER SCRIPT ERROR: ', '').replace('\n', '') + Fore.RESET
        except Exception as error:
            log(error, 'e')
        if newline == True:
            print_text += '\n'
        print(print_text)
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
            'first_launch': True,
            'cat_mod_loader_setup_finished': False,
            "autostart_enabled": False,
            "autostart_timer": 3,
            "autostart": 2,
            'paths': {
                'game': {
                    'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment",
                    'custom': '',
                    'selected': 'default'
                },
                'tools': {
                    'gdre': {
                        'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment\\Tools",
                        'custom': '',
                        'selected': 'default'
                    },
                    'pck_explorer': {
                        'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment\\Tools",
                        'custom': '',
                        'selected': 'default'
                    }
                },
                'game_extracted': {
                    'default': "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Halls of Torment\\Extracted",
                    'custom': '',
                    'selected': 'default'
                },
               'logs': {
                   'game': {
                       'default': f'{os.getenv("APPDATA")}\\HallsOfTorment\\logs\\' #godot.log
                   },
                   'pck_explorer': {
                       'default': f'{os.getenv("APPDATA")}\\GodotPCKExplorer\\' #log.txt
                   }
               }
            },
            'packs': {
                'default': {
                    'pack': 'HallsOfTorment.pck',
                    'exe': 'HallsOfTorment.exe'
                    },
                'modded': {
                    'pack': 'HoT-CatModLoader.pck',
                    'exe': 'HallsOfTorment.exe'
                    },
                'extracted': {
                    'pack': '',
                    'exe': 'HallsOfTorment.exe'}
            }
        },
        'game_settings': {
            'verbose': False,
            'debug': False,
            'console': False,
            'window_settings': {
                'position_enabled': False,
                'position': [10, 10],
                'resolution_enabled': False,
                'resolution': [980, 680]
            }
        },
        'mod_settings': {
            'auto_player': False,
            'auto_trait_selection': True
        },
        'log_settings': {
            'debug': False,
            'error': True
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
    if not settings:
        return
    if search_4:
        try:
            return settings['launcher_settings'][search][search_2][search_3][search_4]
        except Exception as error:
            log(error, 'e')
    elif search_3:
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

def set_launcher_setting(value, search, search_2=None, search_3=None, search_4=None):
    settings = load_settings()
    if not settings:
        return
    if search_4:
        try:
            settings['launcher_settings'][search][search_2][search_3][search_4] = value
        except Exception as error:
            log(error, 'e')
    elif search_3:
        try:
            settings['launcher_settings'][search][search_2][search_3] = value
        except Exception as error:
            log(error, 'e')
    elif search_2:
        try:
            settings['launcher_settings'][search][search_2] = value
        except Exception as error:
            log(error, 'e')
    elif search:
        try:
            settings['launcher_settings'][search] = value
        except Exception as error:
            log(error, 'e')
    save_settings(settings)

def toggle_launcher_setting(setting):
    if not setting:
        return
    value = get_launcher_setting(setting)
    if value == True:
        set_launcher_setting(False, setting)
    if value == False:
        set_launcher_setting(True, setting)

## Launcher Game Commands Functions ##
def create_launch_game_command(pack_file):
    if not pack_file:
        return
    commands = ['start']
    cmd = ''
    cmd_args = ''
    if get_game_setting('console') == True:
        cmd = 'cmd.exe'
        cmd_args = '/K'
    commands.append(cmd)
    commands.append(cmd_args)
    exe = get_launcher_setting('packs', pack_file, 'exe')
    if exe:
        commands.append(exe)
    #try:
    #    position = get_game_setting('position')
    #    commands.append('--position')
    #    commands.append(f'{position[0]},{position[1]}')
    #except Exception as error:
    #    log(error, 'e')
    if get_game_setting('verbose') == True:
        commands.append('--verbose')
    if get_game_setting('debug') == True:
        commands.append('--debug')
    pack = get_launcher_setting('packs', pack_file, 'pack')
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
    try:
        for process in psutil.process_iter(['pid', 'name']):
            if process.info['name'] == 'HallsOfTorment.exe':
                return process.info['pid']
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
    if isinstance(processes, int):
        try:
            psutil.Process(processes['pid']).terminate()
            log(f'Terminated Process: {processes['pid']}', 'd')
        except:
            pass
    elif isinstance(processes, list):
        try:
            for process in processes:
                try:
                    psutil.Process(process['pid']).terminate()
                    log(f'Terminated Process: {process['pid']}', 'd')
                except:
                    pass
        except Exception as error:
            log(error, 'e')


def get_log(log_file, file_size):
    with open(log_file, 'r') as file:
        file.seek(file_size)
        new_lines = file.readlines()
        for index, line in enumerate(new_lines):
            if "USER ERROR:" in line:
                log(line, 'me')
                log(new_lines[index + 1], 'me', newline=True)
            elif "SCRIPT ERROR:" in line:
                log(line, 'me')
                log(new_lines[index + 1], 'me', newline=True)
            if "[CatModLoader]" in line:
                line = line.strip().replace('[CatModLoader] | ', '')
                try:
                    log_text = line.split(' | ')
                except Exception as error:
                    log(error, 'e')
                if len(log_text) > 1:
                    try:
                        mod_name = log_text[0]
                    except Exception as error:
                        log(error, 'e')
                    line = line.replace(mod_name, Fore.LIGHTRED_EX + mod_name + Fore.RESET)
                if "[Version]" in line:
                    _, version = line.split("[Version] | ")
                    line = line.replace(f'[Version] | {version}', '')
                    line += Fore.YELLOW + version + Fore.RESET
                if "[Key]" in line:
                    try:
                        _, __ = line.split('[Key] ')
                        key, func = __.split(' = ')
                        line = line.replace(f'[Key] {key} = {func}', '')
                        func = func.replace(']', '')
                        line += Fore.YELLOW + f'{key}' + Fore.LIGHTWHITE_EX + ' - ' + Fore.LIGHTGREEN_EX + f'{func}'
                    except Exception as error:
                        log(error, 'e')
                log(line, 'mod')
            #elif "ERROR: Failed to load script" in line:
            #    log(line, 'e')
            #elif "ERROR: Script does not inherit from" in line:
            #    log(line, 'e')
            #elif "could not be loaded!" in line:
            #    log(line, 'e')

def watch_game():
    log_file = get_launcher_setting('paths', 'logs', 'game', 'default')
    if not log_file:
        return
    log_file += 'godot.log'
    file_size = 0
    processes = None
    log('[Launch Game]', 'title', newline=True)
    time.sleep(1)
    while True:
        if is_running('HallsOfTorment.exe'):
            if not processes or processes == [] or processes == None:
                try:
                    processes = get_game_processes()
                except Exception as error:
                    log(error, 'e')
                log('processes: ' + str(processes), 'd')
                time.sleep(2)
            current_size = os.path.getsize(log_file)
            if current_size > file_size:
                get_log(log_file, file_size)
                file_size = current_size
            time.sleep(0.1)
        else:
            try:
                exit_processes(processes)
                return
            except KeyboardInterrupt:
                return
            except Exception as error:
                log(error, 'e')
                return

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
    if user_input == 'Y' or user_input == 'y' or user_input == '1' or user_input == '' or user_input == ' ':
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
        if go_back(user_input) == True:
            break
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
    project_file_path = get_launcher_setting('paths', 'game_extracted', 'selected')
    project_file = get_launcher_setting('paths', 'game_extracted', project_file_path) + '\\project.godot'
    if os.path.exists(project_file):
        with open(project_file, 'r') as file:
            lines = file.readlines()
        try:
            _ = lines.index('CatModLoader="*res://CatModLoader/cat_mod_loader.gd"\n')
            return
        except Exception as error:
            log(error, 'e')
        try:
            index = lines.index('[autoload]\n')
        except Exception as error:
            log(error, 'e')
        lines.insert(index + 2, 'CatModLoader="*res://CatModLoader/cat_mod_loader.gd"\n')
        with open(project_file, 'w') as file:
            file.writelines(lines)
    if verify_modloader() == True:
        clear()
        log('[Setup CatModLoader - Add to autoload]', 'title')
        print('')
        log('CatModLoader should now be added to your extracted game.\n', 'info')
        wait()

def verify_modloader():
    project_file_path = get_launcher_setting('paths', 'game_extracted', 'selected')
    project_file = get_launcher_setting('paths', 'game_extracted', project_file_path) + '\\project.godot'
    if not os.path.exists(project_file):
        return False
    with open(project_file, 'r') as file:
        lines = file.readlines()
        try:
            _ = lines.index('CatModLoader="*res://CatModLoader/cat_mod_loader.gd"\n')
            return True
        except Exception as error:
            log(error, 'e')
            return False
            
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
        selected_game_path = get_launcher_setting('paths', 'game', 'selected')
        game_path = get_launcher_setting('paths', 'game', selected_game_path)
        log('[Setup CatModLoader - Paths]', 'title')
        log(f'Set the path to your game folder.\n', 's', step='1')
        log(f'[Default]', 's', step='1')
        log(f'{get_path(game_path)}', 's', step='1')
        if not confirm('Use Default?: [Y/N]: '):
            user_input = input('\nEnter Path: ')
            if confirm('Use Custom Path?: [Y/N]: '):
                set_launcher_setting(user_input, 'paths', 'game', 'custom')
                set_launcher_setting('custom', 'paths', 'game', 'selected')
        clear()
        game_extracted_path = get_launcher_setting('paths', 'game_extracted', 'default')
        log('[Setup CatModLoader - Paths]', 'title')
        log('Set the folder path for your extracted game files.\n ', 's', step='2')
        log('[Default]', 's', step='2')
        log(f'{get_path(game_extracted_path)}', 's', step='2')
        if not confirm('Use Default?: [Y/N]: '):
            user_input = input('\nEnter Path: ')
            if confirm('Use Custom Path?: [Y/N]: '):
                set_launcher_setting(user_input, 'paths', 'game_extracted', 'custom')
                set_launcher_setting('custom', 'paths', 'game_extracted', 'selected')
        clear()
        gdre_path = get_launcher_setting('paths', 'tools', 'gdre', 'default')
        log('[Setup CatModLoader - Paths]', 'title')
        log('Set the folder path to the GDRE Tools.\n', 's', step='3')
        log('[Default]', 's', step='3')
        log(f'{get_path(gdre_path)}', 's', step='3')
        if not confirm('Use Default?: [Y/N]: '):
            user_input = input('\nEnter Path: ')
            if confirm('Use Custom Path?: [Y/N]: '):
                set_launcher_setting(user_input, 'paths', 'tools', 'gdre', 'custom')
                set_launcher_setting('custom', 'paths', 'tools', 'gdre', 'selected')
        break

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
            'newline' : True
        },
        2: {
            'text': 'Add Mod Loader To Game',
            'func': add_modloader_to_game,
            'newline': False
        },
        3: {
            'text': 'Create Pack File',
            'func': create_pack_file,
            'newline': False
        }
    }
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
## Mod Settings Menu ##
def menu_mod_settings():
    clear()
    log('[Mod Settings]', 'title')
    wait()

## Main Menu Functions ##
def menu_option_launch_game(version):
    set_console_size(60, 10)
    os.system('cls')
    commands = create_launch_game_command(version)
    launch_game(commands)
    
def create_main_menu_options():
    # Menu options
    options = {
        0: {
            'text': Fore.LIGHTGREEN_EX + "Start Modded Game" + Fore.RESET,
            'func': menu_option_launch_game,
            'args': 'modded',
            'newline': False},
        1: {
            'text': Fore.LIGHTGREEN_EX + "Start Extracted Game" + Fore.RESET,
            'func': menu_option_launch_game,
            'args': 'extracted',
            'newline': False},
        2: {
            'text': Fore.LIGHTGREEN_EX + "Start Default Game" + Fore.RESET,
            'func': menu_option_launch_game,
            'args': 'default',
            'newline': False},
        3: {
            'text': Fore.LIGHTGREEN_EX + 'Setup & Install CatModLoader' + Fore.RESET,
            'func': setup_catmodloader,
            'newline': True},
        4: {
            'text': Fore.YELLOW + 'Settings' + Fore.RESET,
            'func': menu_launch_settings,
            'newline': True
            },
        5: {
            'text': Fore.LIGHTGREEN_EX + 'Mod Settings' + Fore.RESET,
            'func': menu_mod_settings,
            'newline': False
        },
        6: {
            'text': Fore.CYAN + 'Tools & Setup' + Fore.RESET,
            'func': menu_tools_n_setup,
            'newline': False
        }}
    if options:
        return options

def menu_start():
    set_console_size(60, 15)
    options = create_main_menu_options()
    if get_launcher_setting('first_launch') == True:
        setup_catmodloader()
        set_launcher_setting(False, 'first_launch')
    if get_launcher_setting('autostart_enabled') == True:
        while True:
            while is_running('HallsOfTorment.exe') == True:
                try:
                    time.sleep(0.01)
                except KeyboardInterrupt:
                    return
                except Exception as error:
                    log(error, 'e')
            else:
                try:
                    log('[AutoStart Loading]', 'title')
                    log('Use "CTRL+C" to cancel', 'text')
                    try:
                        time.sleep(get_launcher_setting('autostart_timer'))
                    except KeyboardInterrupt:
                        break
                    try:
                        options[get_launcher_setting('autostart')]['func'](options[get_launcher_setting('autostart')]['args'])
                    except KeyboardInterrupt:
                        break
                    except Exception as error:
                        log(error, 'e')
                except KeyboardInterrupt:
                    break
                except Exception as error:
                    log(error, 'e')
    if get_launcher_setting('cat_mod_loader_setup_finished') == False:
        options[0]['text'] = Fore.RED + 'Start Modded Game' + Fore.RESET
        options[1]['text'] = Fore.RED + 'Start Extracted Game' + Fore.RESET
    else:
        options[3]['text'] = Fore.RED + 'Setup & Install CatModLoader' + Fore.RESET
    # Print menu
    clear()
    log('[Launch Menu]', 'title')
    for index, option in enumerate(options):
        log(f'[{index + 1}] - {options[option]['text']}', 'menu', newline=options[option]['newline'])
    log('Go Back', type='menu-back', newline=True)
    # Get user input 
    try:
        user_input = input('\nOption: ')
    except KeyboardInterrupt:
        pass
    except Exception as error:
        log(error, 'e')
    if user_input == '0' or user_input == 'e' or user_input == 'E':
        return
    # Set user_input to correct value 
    try:
        user_input = int(user_input) - 1
    except Exception as error:
        log(error, 'e')
    # Launch game
    try:
        options[user_input]['func'](options[user_input]['args'])
    except Exception as error:
        try:
            options[user_input]['func']()
        except Exception as error:
            log(error, 'e')
    except Exception as error:
        log(error, 'e')
    while is_running('HallsOfTorment.exe') == True:
        try:
            time.sleep(0.25)
        except KeyboardInterrupt:
            return
        except Exception as error:
            log(error, 'e')

## Start ##
def start():
    while True:
        try:
            menu_start()
        except KeyboardInterrupt:
            wait()

try:
    splash_screen()
except KeyboardInterrupt:
    start()
except Exception as error:
    log(error, 'e')
start()