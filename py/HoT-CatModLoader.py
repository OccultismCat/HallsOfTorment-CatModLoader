import os, sys, time, psutil
from colorama import Fore, init
init()

args = [None, None]

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

def splash_screen():
    os.system('mode con: cols=55 lines=27')
    os.system('cls')
    print(Fore.RED + splash() + Fore.RESET)
    time.sleep(1)
    os.system('cls')
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

def launch_game(args):
    pack_file = 'HoT-CatModLoader.pck'
    if not os.path.exists(pack_file):
        pack_file = 'HallsOfTorment.pck'
    #game_path = "C:\\Github-Repos\\HallsOfTorment-Modding\\"
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
        print(commands)
    try:
        os.system(' '.join(commands))
    except Exception as error:
        print(str(error))

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
    for process in processes:
        try:
            psutil.Process(process['pid']).terminate()
        except Exception as error:
            print(str(error))

def start():
    splash_screen()
    global args
    processes = None
    get_args()
    launch_game(args)
    time.sleep(3)
    while True:
        if is_running('HallsOfTorment.exe'):
            if not processes:
                processes = get_game_processes()
            time.sleep(0.1)
        else:
            exit_processes(processes)
            break
    os.system('pause')

while True:
    start()