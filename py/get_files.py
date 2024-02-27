import os

source_path = r'C:\Program Files (x86)\Steam\steamapps\common\Halls of Torment'
destination_path = os.path.dirname(os.path.realpath(__file__)) + r'\\'

files_to_copy = [
    'HallsOfTorment.exe',
    'HallsOfTorment.pck',
    'steam_api64.dll',
    'steam_appid.txt'
]

for file_name in files_to_copy:
    source_file = os.path.join(source_path, file_name)
    destination_file = os.path.join(destination_path, file_name)

    try:
        with open(source_file, 'rb') as src, open(destination_file, 'wb') as dest:
            dest.write(src.read())
        print(f"File '{file_name}' copied successfully.")
    except FileNotFoundError:
        print(f"File '{file_name}' not found in the source path.")
    except Exception as e:
        print(f"Error copying file '{file_name}': {e}")