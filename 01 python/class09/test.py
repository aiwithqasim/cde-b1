# Define a function named open_file that takes a filename as a parameter.
def open_file(filename):
    try:
        # Attempt to open the specified file in write mode ('w') using a 'with' statement.
        with open(filename, 'w') as file:
            # Try to read the contents of the file, but this code will not be executed because the file is opened in write mode.
            contents = file.read()
            # Print a message to indicate that the file contents will be displayed (this will not happen).
            print("File contents:")
            # Print the contents of the file (this will not happen).
            print(contents)
    except Exception as e:
        print(e)
    except PermissionError:
        print("permission Error")
        # Handle the exception if there is a permission denied error while opening the file.
        print("Error: Permission denied to open the file.")

# Usage
# Prompt the user to input a file name and store it in the 'file_name' variable.
file_name = input("Input a file name: ")
# Call the open_file function with the provided file name, attempting to open the file in write mode.
open_file(file_name)
