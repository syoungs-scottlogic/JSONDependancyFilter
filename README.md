# JSON Dependancy Filter

The script is intended to be used with a JSON dump from a kubernetes log. The use case is to see what dependencies are installed and to be able to filter those dependencies based on packet manager or confluence path.

At the first instance, there is an open to open a file or load `.\input.json`. For speed it can be best to put the JSON file in the same directory as the script and rename the file to `input.json`. If not, simply use the option to load a file.

It is also possible to save the list of dependencies to a text file if required.
