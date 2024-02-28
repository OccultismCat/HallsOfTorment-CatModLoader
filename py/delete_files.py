import os

destination_path = os.path.dirname(os.path.realpath(__file__)) + r'\\'

files_to_delete = [
    'HallsOfTorment.exe',
    'HallsOfTorment.pck',
    'steam_api64.dll',
    'steam_appid.txt',
    'settings.json',
    'HoT-CatModLoader.exe',
]

for file_name in files_to_delete:
    file_path = os.path.join(destination_path, file_name)
    try:
        if file_name == 'HoT-CatModLoader.exe':
            if os.path.exists(file_path):
                print(f'Delete ["{file_name}"]')
                user_input = input(f'\n[Y/N]: ')
                if user_input == 'y' or user_input == 'Y':
                    try:
                        os.remove(file_path)
                    except Exception as error:
                        print(str(error))
                else:
                    exit()
        os.remove(file_path)
        print(f"File '{file_name}' deleted successfully.")
    except FileNotFoundError:
        print(f"File '{file_name}' not found in the destination folder.")
    except Exception as e:
        print(f"Error deleting file '{file_name}': {e}")