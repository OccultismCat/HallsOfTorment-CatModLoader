import os, sys, time, json, psutil, threading
from colorama import Fore, init
init()

args = [None, None]

current_path = os.path.dirname(os.path.realpath(__file__)) + '\\'

version = '0.0.1'

def get_current_path():
    global current_path
    current_path = current_path.replace("\\\\", "\\")
    return current_path

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

pack_files = {
    'default': {
        'file':'HallsOfTorment.pck',
        '':''
    },
    'modded': {
        'file':'HoT-CatModLoader.pck',
        '':'',
    }
}

def log(text, type=None, var=None):
    global version
    if not var:
        var = ''
    title = Fore.YELLOW + ' |' + Fore.LIGHTRED_EX + ' [CatModLoader] ' + Fore.YELLOW + '|' + Fore.GREEN + f' [V{version}] ' + Fore.YELLOW + '| ' + Fore.RESET
    log_start = Fore.YELLOW + '[CatModLoader]: ' + Fore.RESET
    if type == 'title':
        print(str(text) + title + str(var))
    elif type == 'text':
        print(Fore.LIGHTWHITE_EX + str(text) + Fore.RESET)
    elif type == 'menu':
        if var:
            print(Fore.YELLOW + str(text) + f': {var}' + Fore.RESET)
        else:
            print(Fore.YELLOW + str(text) + Fore.RESET)
    elif type == 'error':
        print(log_start + Fore.RED + '[ERROR] | ' + str(text) + '\n' + Fore.RESET)
    elif type == 'debug' or type == 'd':
        print(log_start + Fore.MAGENTA + '[DEBUG] ' + Fore.LIGHTCYAN_EX + str(text) + '\n' + Fore.RESET)
    else:
        print(log_start + Fore.LIGHTWHITE_EX + str(text) + Fore.RESET)

def set_console_size(cols, lines):
    try:
        os.system(f'mode con: cols={cols} lines={lines}')
    except Exception as error:
        print(str(error))

def splash_screen():
    set_console_size(55, 27)
    os.system('mode con: cols=55 lines=27')
    os.system('cls')
    print(Fore.RED + splash() + Fore.RESET)
    time.sleep(1)
    os.system('cls')
    set_console_size(90, 10)
    os.system('mode con: cols=90 lines=10')

def get_arg(index):
    arg = None
    if not index:
        return
    try:
        arg = sys.argv[index]
    except:
        pass
    return arg

def get_args():
    global args
    args[0] = get_arg(1)
    args[1] = get_arg(2)

def get_game_processes():
    try:
        for process in psutil.process_iter(['pid', 'name', 'ppid']):
            if process.info['name'] == 'conhost.exe':
                process_children = get_child_processes(process.info['ppid'])
                for child in process_children:
                    if child['name'] == 'HallsOfTorment.exe':
                        return process_children
    except Exception as error:
        print(str(error))

def is_running(process_name):
    for process in psutil.process_iter(['pid', 'name']):
        if process.info['name'] == process_name:
            return True
    return False

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
    log(processes, 'd')
    for process in processes:
        try:
            psutil.Process(process['pid']).terminate()
        except Exception as error:
            log(error, 'error')

def get_pack_file(search=None):
    if search:
        for file in pack_files:
            if file == search:
                pack_file = pack_files[search]['file']
                return pack_file
    pack_file = pack_files['modded']['file']
    if not os.path.exists(pack_files['modded']['file']):
        pack_file = pack_files['default']['file']
    return pack_file

def watch_game():
    processes = None
    while True:
        if is_running('HallsOfTorment.exe'):
            if not processes:
                processes = get_game_processes()
            time.sleep(0.01)
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
        log(error, 'error')

def launch_game(set_pack_file=None):
    if set_pack_file == 'default':
        pack_file = get_pack_file('default')
    else:
        pack_file = get_pack_file()
    #game_path = "C:\\Github-Repos\\HallsOfTorment-Modding\\"
    if set_pack_file == 'exported':
        commands = [
            'start',
            'cmd.exe',
            '/K',
            'HallsOfTorment.exe',
        ]
    else:
        commands = [
            'start',
            'cmd.exe',
            '/K',
            'HallsOfTorment.exe',
            '--main-pack',
            f'{pack_file}'
        ]
    if args:
        for arg in args:
            if arg != None:
                commands.append(arg)
    if not os.path.exists(commands[3]):
        log(f"Couldn't find {commands[3]}!", 'error')
        time.sleep(3)
        return
    try:
        os.system(' '.join(commands))
    except Exception as error:
        print(str(error))
    watch_game_thread()

def menu_option_launch_modded_game():
    set_console_size(90, 10)
    os.system('cls')
    launch_game()

def menu_option_launch_game():
    set_console_size(90, 10)
    os.system('cls')
    launch_game('default')

def menu_option_launch_exported_game():
    set_console_size(90, 10)
    os.system('cls')
    launch_game('exported')

def create_settings():
    settings_data = {
        "launcher_settings": {
            "arg1": "",
            "arg2": "",
            "autostart_enabled": False,
            "autostart": 0
        },
    }
    with open('settings.json', 'w') as file:
        json.dump(settings_data, file, indent=4)

def save_settings(settings):
    if not settings:
        return
    with open('settings.json', 'w+') as file:
        json.dump(settings, file, indent=4)

def get_launcher_setting(search):
    if not search:
        return
    settings = load_launch_settings()
    try:
        return settings['launcher_settings'][search]
    except Exception as error:
        log(error, 'error')

def set_launcher_setting(setting, value):
    settings = load_launch_settings()
    if not settings:
        return
    try:
        settings['launcher_settings'][setting] = value
        log(settings['launcher_settings'][setting], 'd')
        log(setting, 'd')
        log(value, 'd')
        os.system('pause')
    except Exception as error:
        log(error, 'error')
    save_settings(settings)

def toggle_launcher_setting(setting):
    settings = load_launch_settings()
    if not setting:
        return
    try:
        setting_value = settings['launcher_settings'][setting]
    except Exception as error:
        log(error, 'error')
    if setting_value == False:
        set_launcher_setting(setting, True)
    elif setting_value == True:
        set_launcher_setting(setting, False)

def load_launch_settings():
    if not os.path.exists('settings.json'):
        create_settings()
    try:
        with open('settings.json', 'r') as file:
            settings = json.load(file)
            return settings
    except Exception as error:
        log(error, 'error')

def menu_settings():
    while True:
        os.system('cls')
        options = [
            ['Auto Start Game', str(get_launcher_setting('autostart_enabled'))]
        ]
        log('[Launch Settings]', 'title')
        for index, option in enumerate(options):
            log(f'[{(index + 1)}] - {option[0]}', 'menu', option[1])
        user_input = input('\nOption: ')
        if user_input == '0' or user_input == 'e':
            return
        elif user_input == '1':
            toggle_launcher_setting('autostart_enabled')

def auto_menu_start(options):
    log('[AutoStart Loading]', 'title')
    log('Use "CTRL+C" to cancel', 'text')
    try:
        time.sleep(5)
    except KeyboardInterrupt:
        os.system('cls')
        return
    try:
        options[get_launcher_setting('autostart')][1]()
    except Exception as error:
        log(error, 'error')

def menu_start():
    settings = load_launch_settings()
    set_console_size(60, 10)
    options = [
        ['Start Modded Game', menu_option_launch_modded_game],
        ['Start Default Game', menu_option_launch_game],
        ['Start Exported Game', menu_option_launch_exported_game],
        ['Settings', menu_settings]
        ]
    if get_launcher_setting('autostart_enabled') == True:
        auto_menu_start(options)
    log('[Launch Menu]', 'title')
    for index, option in enumerate(options):
        log(f'[{(index + 1)}] - {option[0]}', 'menu')
    user_input = input('\nOption: ')
    try:
        options[int(user_input) - 1][1]()
    except Exception as error:
        print(str(error))
    while True:
        if is_running('HallsOfTorment.exe'):
            time.sleep(1)
        else:
            break

def start():
    while True:
        menu_start()

splash_screen()
start()