import os

def delete_directory(directory_path):
    for root, dirs, files in os.walk(directory_path, topdown=False):
        for file in files:
            file_path = os.path.join(root, file)
            try:
                os.remove(file_path)
                print(f"File '{file_path}' deleted successfully.")
            except Exception as e:
                print(f"Error deleting file '{file_path}': {e}")

        try:
            os.rmdir(root)
            print(f"Folder '{root}' deleted successfully.")
        except Exception as e:
            print(f"Error deleting folder '{root}': {e}")

def copy_file(src, dst):
    with open(src, 'rb') as src_file:
        with open(dst, 'wb') as dst_file:
            dst_file.write(src_file.read())

destination_path = r'C:\Github-Repos\HallsOfTorment-CatModLoader\py'

# Run pyinstaller command
pyinstaller_command = 'pyinstaller --clean --onefile --icon=CatModLoader.ico "HoT-CatModLoader.py" --noconfirm'
exit_code = os.system(pyinstaller_command)

if exit_code == 0:
    print("PyInstaller command executed successfully.")
else:
    print(f"Error executing PyInstaller command. Exit code: {exit_code}")
    exit()

# Move "HoT-CatModLoader.exe" from "dist" to the current script's running directory
source_exe_path = os.path.join(destination_path, 'dist', 'HoT-CatModLoader.exe')
destination_exe_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'HoT-CatModLoader.exe')

try:
    os.rename(source_exe_path, destination_exe_path)
    print(f"File 'HoT-CatModLoader.exe' moved successfully to '{destination_exe_path}'.")

    # Copy "HoT-CatModLoader.exe" to the parent directory without shutil
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    copy_destination_path = os.path.join(parent_dir, 'HoT-CatModLoader.exe')
    copy_file(destination_exe_path, copy_destination_path)
    print(f"File 'HoT-CatModLoader.exe' copied to '{copy_destination_path}'.")
except Exception as e:
    print(f"Error moving/copying 'HoT-CatModLoader.exe': {e}")

# Files and folders to delete after moving/copying "HoT-CatModLoader.exe"
files_and_folders_to_delete = [
    'HoT-CatModLoader.spec',
    'build',
    'dist'
]

for item_name in files_and_folders_to_delete:
    item_path = os.path.join(destination_path, item_name)

    try:
        if os.path.isfile(item_path):
            # If it's a file, delete it
            os.remove(item_path)
            print(f"File '{item_name}' deleted successfully.")
        elif os.path.isdir(item_path):
            # If it's a directory, use custom function to delete it and its contents
            delete_directory(item_path)
            print(f"Folder '{item_name}' and its contents deleted successfully.")
        else:
            print(f"Path '{item_path}' does not exist.")
    except Exception as e:
        print(f"Error deleting '{item_name}': {e}")