import os

destination_path = r'C:\Github-Repos\HallsOfTorment-CatModLoader'

files_to_delete = [
    'HallsOfTorment.exe',
    'HallsOfTorment.pck',
    'steam_api64.dll',
    'steam_appid.txt'
]

for file_name in files_to_delete:
    file_path = os.path.join(destination_path, file_name)

    try:
        # Delete the file in the destination folder
        os.remove(file_path)
        print(f"File '{file_name}' deleted successfully.")
    except FileNotFoundError:
        print(f"File '{file_name}' not found in the destination folder.")
    except Exception as e:
        print(f"Error deleting file '{file_name}': {e}")