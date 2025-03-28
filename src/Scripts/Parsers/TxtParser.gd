extends Object
class_name TxtParser
## Made by Yni, licensed under CC0.

## Saves TXT file
func save(path: String, content: String):
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(content)
	file.close()

## Loads TXT file
func open(path: String):
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	file.close()
	return content
